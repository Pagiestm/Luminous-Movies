const RatingsServices = require("../services/RatingsServices");

class RatingsControllers{
    getRatings(){
        return async (req, res) => {
            const response = await RatingsServices.getRatings();
            res.send(response); 
        }
    }

    getRatingsByMovie(){
        return async (req, res) => {
            const id = req.params.id;
            const response = await RatingsServices.getRatingsByMovie(id);
            res.send(response); 
        }
    }

    getRatingsByUser(){
        return async (req, res) => {
            const id = req.params.id;
            const response = await RatingsServices.getRatingsByUser(id);
            res.send(response);
        }
    }

    getRatingById(){
        return async (req, res) => {
            const id = req.params.id;
            const response = await RatingsServices.getRatingById(id);
            res.send(response); 
        }
    }

    addRating(){
        return async (req, res) => {
            const movies = req.body.movies;
            const users = req.body.users;
            const rating = req.body.rating;
            if (movies == null || users == null || rating == null) {
                return res.send({error: "Données manquante"});
            }

            const occurence = await RatingsServices.getRatingByUserAndMovie(users, movies);
            if (occurence != null) {
                return res.send({error: "Note déjà émise"});
            }
            try {
                const response = await RatingsServices.addRating(movies, users, rating);
                return res.send(response);
            } catch (err) {
                throw err;
            }
        }
    }

    updateRating(){
        return async (req, res) => {
            const id = req.params.id;
            const rating = req.body.rating;
            const response = await RatingsServices.updateRating(id, rating);
            res.send(response);
        }
    }

    deleteRating(){
        return async(req, res) => {
            const id = req.params.id;
            const response = await RatingsServices.deleteRating(id);
            res.send(response);
        }
    }
}

module.exports = new RatingsControllers();