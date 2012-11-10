app = app || {}

$ ->

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
			'click #create-book': 'createBook'
		initialize: ->
			this.title = $ '#title'
		createBook: ( e ) ->
			if( app.Books.create( this.newBookData() ) )
				this.clearForm()
		newBookData: ->
			return
				title: this.title.val()

		clearForm: ->
			this.title.val( '' )
	
	new app.AppView
