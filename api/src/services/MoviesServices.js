const Favorites = require('../models/Favorites');
const Movies = require('../models/Movies');
const Categories = require('../services/CategoriesServices');
const FavoritesServices = require('./FavoritesServices');
const Services = require('./Services');

class MoviesServices extends Services {
    async getMovies(){
        try {
            const movies = await Movies
            .find()
            .populate('categories');

            const moviesWithCategories = movies.map(movie => {
                const categoryNames = movie.categories.map(category => category.name);
                
                return {
                    ...movie.toObject(),
                    categories: categoryNames
                };
            });

            return moviesWithCategories;
        } catch (error) {
            throw error;
        }
    }

    async getMoviesByUserFavorites(userId){
        try {
            const favorites = await FavoritesServices.getFavoritesByUser(userId);
            let movies = [];
            for (const favorite in favorites) {
                movies.push(await Movies.findById(favorite._id));
            }
            return movies;
        } catch (error) {
            throw error;
        }
    }

    async getMoviesByCategorie(categorieName){
        try {
            const categorie = await Categories.getCategorieByName(categorieName);
            const movies = await Movies.find({categories: categorie._id}); 
            return movies;
        } catch (error) {
            throw error;
        }
    }

    async getMoviesByTitle(title){
        try {
            const movies = await Movies.find({title: {$regex: title, $options: 'i'}});
            return movies;
        } catch (error) {
            throw error;
        }
    }

    async getMovieById(id){
        try {
            const movie = await Movies.findOne({_id: id});
            return movie;
        } catch (error) {
            throw error;
        }
    }
    
    async addMovie(title, synopsis, image, staring, release_date, length, categories){
        try {
            const movie = new Movies({
                title: title,
                synopsis: synopsis,
                image: image,
                staring: staring,
                release_date: release_date,
                length: length,
                categories: categories
            });
            await movie.save();
            return movie;
        } catch (error) {
            throw error;
        }
    }

    async updateMovie(id, title, synopsis, image, staring, release_date, length, categorie){
        try {
            const movie = await Movies.findOneAndUpdate({_id: id}, {
                title: title, 
                synopsis: synopsis,
                image: image,
                staring: staring,
                release_date: release_date,
                length: length,
                categorie: categorie
            });
            return movie;
        } catch (error) {
            throw error;
        }
    }

    async deleteMovie(id){
        try {
            const movie = await Movies.findByIdAndDelete({_id: id});
            return movie;
        } catch (error) {
            throw error;
        }
    }
}

module.exports = new MoviesServices();