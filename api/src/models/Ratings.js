const mongoose = require("mongoose");

const Ratings = mongoose.model("Ratings", {
    movies: {type: mongoose.ObjectId, ref: 'Movies', required: true},
    users: {type: mongoose.ObjectId, ref: 'Users', required: true},
    rating: {type: Number, required: true}
});

module.exports = Ratings;