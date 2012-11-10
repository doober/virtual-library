
HomeView = Backbone.View.extend
	initialize: ->
		this.render()
	tagName: 'form'
	render: ->
		this.$el.html '<input type="text" placeholder="title" name="title" /><input type="submit" class="button" />'
		return this
	insert: ->
		$('#main').html this.el

AppRouter = Backbone.Router.extend
	routes:
		'': 'home'
	home: ->
		this.homeView = new HomeView()
		this.homeView.insert()

$ ->
	router = new AppRouter

	console.log router

	Backbone.history.start
		pushState: true
