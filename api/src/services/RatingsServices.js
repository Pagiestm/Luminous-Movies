const Ratings = require('../models/Ratings');
const Users = require('../services/UsersServices');
const Movies = require('../services/MoviesServices');
const Services = require('./Services');

class RatingsServices extends Services {
    async getRatings(){
        try {
            const ratings = await Ratings.find(); 
            return ratings;
        } catch (error) {
            throw error;
        }
    }

    async getRatingsByMovie(movieId){
        try {
            const movie = await Movies.getMovieById(movieId);
            const ratings = await Ratings.find({movies: movie._id});
            return ratings;
        } catch (error) {
            throw error;
        }
    }

    async getRatingsByUser(userId){
        try {
            const user = await Users.getUserById(userId);
            const ratings = await Ratings.find({users: user._id});
            return ratings;
        } catch (error) {
            throw error;
        }
    }

    async getRatingByUserAndMovie(userId, movieId){
        try {
            const user = await Users.getUserById(userId);
            const movie = await Movies.getMovieById(movieId);
            const rating = await Ratings.findOne({users: user._id, movies: movie._id});
            return rating;
        } catch (error) {
            throw error;
        }
    }

    async getRatingById(id){
        try {
            const rating = await Ratings.findOne({_id: id});
            return rating;
        } catch (error) {
            throw error;
        }
    }
    
    async addRating(movies, users, user_rating){
        try {
            const rating = new Ratings({
                movies: movies,
                users: users,
                rating: user_rating
            });
            await rating.save();
            return rating;
        } catch (error) {
            throw error;
        }
    }

    async updateRating(id, rating){
        try {
            const rating = await Ratings.findOneAndUpdate({_id: id}, {
                rating: user_rating
            });
            return rating;
        } catch (error) {
            throw error;
        }
    }

    async deleteRating(id){
        try {
            const rating = await Ratings.findByIdAndDelete({_id: id});
            return rating;
        } catch (error) {
            throw error;
        }
    }
}

module.exports = new RatingsServices();