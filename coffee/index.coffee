express = require 'express'
assets = require 'connect-assets'
stylus = require 'stylus'
mongoose = require 'mongoose'

exports.app = app = express()
app.use assets()
app.use( express.bodyParser() )
app.use(express.methodOverride())
app.set 'view engine', 'jade'

mongoose.connect 'mongodb://localhost/virtual-lib'

Book = new mongoose.Schema
	title:
		type: String
		required: true

BookModel = mongoose.model 'Book', Book

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
		return if err then console.log err else console.log "created"

	return res.send book

app.listen 80
