express = require 'express'
assets = require 'connect-assets'
stylus = require 'stylus'
mongoose = require 'mongoose'
passport = require 'passport'
BrowserIDStrategy = require( 'passport-browserid' ).Strategy

exports.app = app = express()
app.use assets()
app.use( express.static( __dirname + '/../public' ) )
app.use express.cookieParser()
app.use express.bodyParser()
app.use express.methodOverride()
app.set 'view engine', 'jade'
app.use express.session({ secret: 'keyboard cat' })
app.use passport.initialize()
app.use passport.session()
app.use app.router

mongoose.connect 'mongodb://localhost/virtual-lib'

# MODELS
Book = new mongoose.Schema
	title:
		type: String
		required: true
	user_id:
		type: String
		required: true
BookModel = mongoose.model 'Book', Book

User = new mongoose.Schema
	email:
		type: String
		required: true
		unique: true
UserModel = mongoose.model 'User', User


passport.serializeUser (user, done) ->
	done null, user._id

passport.deserializeUser (id, done) ->
	UserModel.findOne id, (err, user) ->
		done err, user

passport.use new BrowserIDStrategy
	audience: 'http://localhost',
	( email, done ) ->
		#process.nextTick goes to the next 'tick' in the event loop
		process.nextTick ->
			UserModel.findOne(
				{ email: email },
				'id',
				( err, user ) ->
					if err
						console.log err

					if ! user?
						user = new UserModel { email: email }
						user.save ( err ) ->
							if err
							else
								console.log "created user"
					done null, user
			)

		return

app.post '/auth/browserid',
	passport.authenticate 'browserid', { failureRedirect: '/login', successRedirect: '/' }

getAllBooks = ->
	BookModel.find ( err, books ) ->
		return if err then console.log err else res.send books

app.get '/', ( req, res ) ->
	if req.isAuthenticated()
		res.render 'index'
	else
		res.render 'home'

ensureAuthenticated = ( req, res, next ) ->
	if req.isAuthenticated()
		next()
	else
		res.redirect '/'

app.get '/api/books', ensureAuthenticated, ( req, res ) ->
	return BookModel.find ( err, books ) ->
		return if err then console.log err else res.send books

app.post '/api/books', ensureAuthenticated, ( req, res ) ->
	console.log "POST: "
	console.log req.body

	book = new BookModel
		title: req.body.title
		user_id: req.user._id

	book.save (err) ->
		return if err then console.log err else console.log "created book"

	return res.send book

app.listen 80
