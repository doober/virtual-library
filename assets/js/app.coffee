app = app || {}

app.Book = Backbone.Model.extend
	defaults:
		title: ''
	validate: ->
		console.log( 'validate' )
		if ( '' == title )
			return "Title may not be empty"
	isValid: ->
		console.log( 'isValid' )
		return '' != title

BookList = Backbone.Collection.extend
	model: app.Book
	url: '/api/books'

app.Books = new BookList

app.AppView = Backbone.View.extend
	el: '#main'
	events:
		'click #add-book': 'showAddBookForm',
		'click .close': 'hideAddBookForm',
		'click #create-book': 'createBook'
	initialize: ->
		this.title = $ '#title'
	showAddBookForm: ->
		$( '.add-book-panel' ).css( { opacity:1, width:'150%' } )
	hideAddBookForm: ->
		$( '.add-book-panel' ).css( { opacity:0, width:'0' } )
	createBook: ( e ) ->
		if ( app.Books.create( this.newBookData() ) )
			this.clearForm()
			this.hideAddBookForm()
	newBookData: ->
		title: this.title.val()

	clearForm: ->
		this.title.val( '' )


$ ->
	new app.AppView

	$('#browserid' ).click ->
		navigator.id.getVerifiedEmail (assertion) ->
			if assertion
				$( "input" ).val assertion
				$( "form" ).submit()

				