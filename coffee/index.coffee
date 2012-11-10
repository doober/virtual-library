express = require 'express'
assets = require 'connect-assets'
stylus = require 'stylus'
mongoose = require 'mongoose'
passport = require 'passport'
BrowserIDStrategy = require( 'passport-browserid' ).Strategy

exports.app = app = express()
app.use assets()
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
BookModel = mongoose.model 'Book', Book

User = new mongoose.Schema
	email:
		type: String
		required: true
		unique: true
UserModel = mongoose.model 'User', User


passport.serializeUser (user, done) ->
	done null, user.id

passport.deserializeUser (id, done) ->
	User.findOne id, (err, user) ->
		done err, user


#AUTH
passport.use new BrowserIDStrategy
	audience: 'http://localhost',
	( email, done ) ->
		#process.nextTick goes to the next 'tick' in the event loop
		process.nextTick ->
			user = new UserModel { email: email }
			user.save ( err ) ->
				return if err then console.log( err ) else console.log "created user"
			done null, { user: user }
		return

app.post '/auth/browserid', 
	passport.authenticate 'browserid', { failureRedirect: '/login' }
	( req, res ) ->
		console.log res
		res.redirect '/'



getAllBooks = ->
	BookModel.find ( err, books ) ->
		return if err then console.log err else res.send books

app.get '/', ( req, res ) ->
	res.render 'index'

app.get '/api/books', ( req, res ) ->
	return BookModel.find ( err, books ) ->
		return if err then console.log err else res.send books

app.post '/api/books', ( req, res ) ->
	req.accepts( 'json' )
	console.log "POST: "
	console.log req.body

	book = new BookModel
		title: req.body.title

	book.save (err) ->
		return if err then console.log err else console.log "created book"

	return res.send book

app.listen 80
