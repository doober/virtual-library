express = require 'express'
passport = require 'passport'
mongoose = require 'mongoose'
BrowserIDStrategy = require( 'passport-browserid' ).Strategy;

app = require('./index').app
app.use express.cookieParser()
app.use express.bodyParser()
app.use express.session({ secret: 'keyboard cat' })
app.use passport.initialize()
app.use passport.session()
app.use app.router

User = new mongoose.Schema
	email:
		type: String
		required: true
		unique: true

UserModel = mongoose.model 'User', User


passport.serializeUser (user, done) ->
  done null, user.email

passport.deserializeUser (email, done) ->
  done null, { user: user }

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






app.get '/login', ( req, res ) ->
	res.render 'user/login', { user: req.user }

 # POST /auth/browserid
 #   Use passport.authenticate() as route middleware to authenticate the
 #   request.  BrowserID authentication will verify the assertion obtained from
 #   the browser via the JavaScript API.
app.post '/auth/browserid', 
	passport.authenticate 'browserid', { failureRedirect: '/login' }
	( req, res ) ->
		console.log res
		res.redirect '/'

# app.get '/logout', ( req, res ) ->
# 	req.logout()
# 	res.redirect '/'

# ensureAuthenticated = ( req, res, next ) ->
# 	console.log res
# 	res.redirect '/login' unless req.isAuthenticated()
# 	next()



