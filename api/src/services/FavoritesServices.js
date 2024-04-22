const Favorites = require('../models/Favorites');
const Users = require('../services/UsersServices');
const Movies = require('../services/MoviesServices');
const Services = require('./Services');

class FavoritesServices extends Services {
    async getFavorites(){
        try {
            const favorites = await Favorites.find(); 
            return favorites;
        } catch (error) {
            throw error;
        }
    }

    async getFavoritesByMovie(movieId){
        try {
            const movie = await Movies.getMovieById(movieId);
            const favorites = await Favorites.find({movies: movie._id});
            return favorites;
        } catch (error) {
            throw error;
        }
    }

    async getFavoritesByUser(userId){
        try {
            const user = await Users.getUserById(userId);
            const favorites = await Favorites.find({users: user._id});
            return favorites;
        } catch (error) {
            throw error;
        }
    }

    async getFavoriteByUserAndMovie(userId, movieId){
        const user = await Users.getUserById(userId);
        const movie = await Movies.getMovieById(movieId);
        const favorite = await Favorites.findOne({users: user._id, movies: movie._id});
        return favorite;
    }

    async getFavoriteById(id){
        try {
            const favorite = await Favorites.findOne({_id: id});
            return favorite;
        } catch (error) {
            throw error;
        }
    }
    
    async addFavorite(movies, users){
        try {
            const favorite = new Favorites({
                movies: movies,
                users: users
            });
            await favorite.save();
            return favorite;
        } catch (error) {
            throw error;
        }
    }

    async deleteFavorite(id){
        try {
            const favorite = await Favorites.findByIdAndDelete({_id: id});
            return favorite;
        } catch (error) {
            throw error;
        }
    }
}

module.exports = new FavoritesServices();