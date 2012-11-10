passport = require 'passport'
BrowserIDStrategy = require( 'passport-browserid' ).Strategy;
app = require('./index').app

passport.use new BrowserIDStrategy
	audience: 'http://localhost',
	( email, done ) ->
		#process.nextTick goes to the next 'tick' in the event loop
    	process.nextTick ->
    		done null, { email: email }



User = new mongoose.Schema
	email:
		type: String
		required: true

UserModel = mongoose.model 'User', User






app.get '/login', ( req, res ) ->
	res.render 'user/login', { user: req.user }

 # POST /auth/browserid
 #   Use passport.authenticate() as route middleware to authenticate the
 #   request.  BrowserID authentication will verify the assertion obtained from
 #   the browser via the JavaScript API.
app.post '/auth/browserid', 
	passport.authenticate 'browserid', { failureRedirect: '/login' },
	( req, res ) ->
    	res.redirect '/'

# app.get '/logout', ( req, res ) ->
# 	req.logout()
# 	res.redirect '/'

ensureAuthenticated = ( req, res, next ) ->
  res.redirect '/login' unless req.isAuthenticated()
  next()



