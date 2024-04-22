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

    getFavoritesByUserAndMovie(){
        return async (req, res) => {
            const idUser = req.params.iduser;
            const idMovie = req.params.idmovie;
            const response = await FavoritesServices.getFavoriteByUserAndMovie(idUser, idMovie);
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
            const movies = req.params.movies;
            const users = req.params.users;
            const response = await FavoritesServices.deleteFavorite(movies, users);
            res.send(response);
        }
    }
}

module.exports = new FavoritesControllers();