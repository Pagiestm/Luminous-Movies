const mongoose = require("mongoose");

const Movies = mongoose.model('Movies', {
    title: {type: String, required: true},
    synopsis: {type: String, required: true},
    image: {type: String, required: true},
    staring: {type: [String], required: true},
    release_date: {type: String, required: true},
    length: {type: String, required: true},
    categories: {type: [mongoose.ObjectId], ref: 'Categories', required: true}
});

module.exports = Movies;