app = app || {}

app.Book = Backbone.Model.extend
	defaults:
		title: '',
		author: '',
		wantIt: 1
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


app.BookView = Backbone.View.extend
	template: _.template '<li><%= title %>, by <%= author %></li>'
	initialize: ->
		this.render()
	render: ->
		this.$el.html( this.template this.model.toJSON() )
		return this



app.AppView = Backbone.View.extend
	el: '#main'
	events:
		'click #add-book': 'showAddBookForm',
		'click #add-book.active': 'hideAddBookForm',
		'click .close': 'hideAddBookForm',
		'click #create-book': 'createBook'

	initialize: ->
		app.Books.fetch()

		app.Books.on( 'add', this.addOne, this )
		app.Books.on( 'reset', this.addAll, this )

		this.title = $( '#title' )
		this.author = $( '#author' )
		this.wantIt = $( '[name="own_it"]' )
		this.render()

	render: ->
		this.addAll()
		return this

	addOne: ( book ) ->
		view = new app.BookView { model: book }
		$('#book-list').prepend( view.render().el )

	addAll: ->
			this.$('#book-list').html ''
			app.Books.each this.addOne, this

	showAddBookForm: ( e ) ->
		$( e.target ).text( 'cancel' ).addClass 'active'
		$( '.add-book-panel' ).addClass 'showing'

	hideAddBookForm: ->
		$( '#add-book.active' ).text( 'Add book' ).removeClass 'active'
		$( '.add-book-panel' ).removeClass 'showing'

	createBook: ( e ) ->
		if ( app.Books.create( this.newBookData() ) )
			this.clearForm()
			this.hideAddBookForm()

	newBookData: ->
		title: this.title.val()
		author: this.author.val()
		wantIt: this.wantIt.val()

	clearForm: ->
		this.title.val( '' )


$ ->
	new app.AppView

	$('#browserid' ).click ->
		navigator.id.getVerifiedEmail (assertion) ->
			if assertion
				$( "input" ).val assertion
				$( "form" ).submit()

				