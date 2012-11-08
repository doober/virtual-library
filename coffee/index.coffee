express = require 'express'
assets = require 'connect-assets'
stylus = require 'stylus'
app = express()
app.use assets()
app.set 'view engine', 'jade'

homepage = ( req, res ) ->
	links = [
		{ label: 'Handlebars', url: 'http://handlebarsjs.com/' }
		{ label: 'CoffeeScript', url: 'http://coffeescript.org/' }
		{ label: 'Passport', url: 'http://passportjs.org/' }
		{ label: 'NodeJitsu Handbook', url: 'https://github.com/nodejitsu/handbook/' }
		{ label: 'The Little Book on CoffeeScript', url: 'http://arcturo.github.com/library/coffeescript/index.html' }
		{ label: 'Vim CoffeeScript Syntax Highlighting', url: 'https://github.com/kchmck/vim-coffee-script' }
		{ label: 'GitHub Project', url: 'https://github.com/doober/virtual-library' }
		{ label: 'Do Project', url: 'https://www.do.com/213079/projects/392489' }
		{ label: 'NodeJitsu Project', url: 'http://dbernar1.virtual-library.jit.su/' }
		{ label: 'Jasmine', url: 'http://pivotal.github.com/jasmine/' }
		{ label: 'Example Express w/ CoffeeScript Project', url: 'https://github.com/twilson63/express-coffee' }
		{ label: 'In-browser Wireframes', url: 'http://wireframe.cc/' }
		{ label: 'Jade', url: 'https://github.com/visionmedia/jade' }
		{ label: 'CDNjs', url: 'http://cdnjs.com/' }
		{ label: 'connect-assets', url: 'https://github.com/TrevorBurnham/connect-assets' }
		{ label: 'ZURB Foundation', url: 'http://foundation.zurb.com/' }
		{ label: 'Stylus Docs', url: 'http://learnboost.github.com/stylus/' }
	]
	res.render 'index', links: links

app.get '/', homepage

app.listen 80
