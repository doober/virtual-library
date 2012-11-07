express = require 'express'
Handlebars = require 'handlebars'
app = express()

homepage = ( req, res ) ->
	links = [
		{ label: 'Handlebars', url: 'http://handlebarsjs.com/' },
		{ label: 'CoffeeScript', url: 'http://coffeescript.org/' },
		{ label: 'Passport', url: 'http://passportjs.org/' },
		{ label: 'NodeJitsu Handbook', url: 'https://github.com/nodejitsu/handbook/' },
		{ label: 'The Little Book on CoffeeScript', url: 'http://arcturo.github.com/library/coffeescript/index.html' },
		{ label: 'Vim CoffeeScript Syntax Highlighting', url: 'https://github.com/kchmck/vim-coffee-script' },
		{ label: 'GitHub Project', url: 'https://github.com/doober/virtual-library' },
		{ label: 'Do Project', url: 'https://www.do.com/213079/projects/392489' },
		{ label: 'NodeJitsu Project', url: 'http://dbernar1.virtual-library.jit.su/' }
	]
	source = '<h1>Resources</h1><ul>{{#each links}}<li><a target="_blank" href="{{this.url}}">{{this.label}}</a></li>{{/each}}</ul>'
	template = Handlebars.compile source
	res.send template links: links

app.get '/', homepage

app.listen 80
