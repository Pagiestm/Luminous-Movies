const FavoritesServices = require("../services/FavoritesServices");

class FavoritesControllers{
    getFavorites(){
        return async (req, res) => {
            const response = await FavoritesServices.getFavorites();
            res.send(response); 
        }
    }

    getFavoritesByMovie(){
        return async (req, res) => {
            const id = req.params.id;
            const response = await FavoritesServices.getFavoritesByMovie(id);
            res.send(response); 
        }
    }

    getFavoritesByUser(){
        return async (req, res) => {
            const id = req.params.id;
            const response = await FavoritesServices.getFavoritesByUser(id);
            res.send(response);
        }
    }

    getFavoriteById(){
        return async (req, res) => {
            const id = req.params.id;
            const response = await FavoritesServices.getFavoriteById(id);
            res.send(response); 
        }
    }

    addFavorite(){
        return async (req, res) => {
            const movies = req.body.movies;
            const users = req.body.users;
            if (movies == null || users == null) {
                return res.send({error: "Données manquante"});
            }

            const occurence = await FavoritesServices.getFavoriteByUserAndMovie(users, movies);
            if (occurence != null) {
                return res.send({error: "Favoris déjà émis"});
            }
            try {
                const response = await FavoritesServices.addFavorite(movies, users);
                return res.send(response);
            } catch (err) {
                throw err;
            }
        }
    }

    deleteFavorite(){
        return async(req, res) => {
            const id = req.params.id;
            const response = await FavoritesServices.deleteFavorite(id);
            res.send(response);
        }
    }
}

module.exports = new FavoritesControllers();