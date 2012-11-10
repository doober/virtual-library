Backbone = require 'backbone'

AppRouter = Backbone.Router.extend
	routes:
		'': 'home'
	home: ->
		this.homeView = new HomeView
		this.homeView.render().insert()

describe 'AppRouter', ->
	router = new AppRouter

	it 'has a "home" route', ->
		expect( router.routes[ '' ] ).toEqual( 'home' )
