var mongoose = require('mongoose');
mongoose.connect('mongodb://localhost/just_some_test');
var Schema = mongoose.Schema;

var Book = new Schema( {
	title: { type: String, required: true }
} );

var BookModel = mongoose.model('Book', Book);  

var book = new BookModel({
	title: 'Something'
});

book.save(function (err) {
	if (!err) {
		return console.log("created");
	} else {
		return console.log(err);
	}
});

var books = BookModel.find(function (err, books) {
	if (!err) {
		return console.log(books);
	} else {
		return console.log(err);
	}
});
