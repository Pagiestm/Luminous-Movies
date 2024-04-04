const mongoose = require("mongoose");

const Favorites = mongoose.model("Favorites", {
    movies: {type: mongoose.ObjectId, ref: 'Movies', required: true},
    users: {type: mongoose.ObjectId, ref: 'Users', required: true}
});

module.exports = Favorites;