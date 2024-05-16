const MoviesServices = require("../services/MoviesServices");

class MoviesControllers{
    getMovies(){
        return async (req, res) => {
            const response = await MoviesServices.getMovies();
            res.send(response); 
        }
    }

    getMoviesByCategorie(){
        return async (req, res) => {
            const categorie = req.params.categorie;
            const response = await MoviesServices.getMoviesByCategorie(categorie);
            res.send(response);
        }
    }

    getMoviesByUserFavorites(){
        return async (req, res) => {
            const id = req.params.id;
            const response = await MoviesServices.getMoviesByUserFavorites(id);
            res.send(response);
        }
    }
    
    getMoviesByTitle(){
        return async (req, res) => {
            const title = req.params.title;
            const response = await MoviesServices.getMoviesByTitle(title);
            res.send(response);
        }
    }

    getMovieById(){
        return async (req, res) => {
            const id = req.params.id;
            const response = await MoviesServices.getMovieById(id);
            res.send(response); 
        }
    }

    addMovie(){
        return async (req, res) => {
            const title = req.body.title;
            const synopsis = req.body.synopsis;
            const image = req.body.image;
            const staring = req.body.staring;
            const release_date = req.body.release_date;
            const length = req.body.length;
            const categories = req.body.categories;

            if (title == null || synopsis == null || image == null || staring == null ||  release_date == null || length == null || categories == null) {
                return res.send({error: "Données manquante"});
            }

            try {
                let staringSplit = staring.split("|-|");
                let categoriesSplit = categories.split("|-|");
                const response = await MoviesServices.addMovie(title, synopsis, image, staringSplit, release_date, length, categoriesSplit);
                return res.send(response);
            } catch (err) {
                throw err;
            }
        }
    }

    updateMovie(){
        return async (req, res) => {
            const id = req.params.id;
            const title = req.body.title;
            const synopsis = req.body.synopsis;
            const image = req.body.image;
            const staring = req.body.staring;
            const release_date = req.body.release_date;
            const length = req.body.length;
            const categories = req.body.categories;

            if (title == null || synopsis == null || image == null || staring == null ||  release_date == null || length == null || categories == null) {
                return res.send({error: "Données manquante"});
            }

            try {
                let staringSplit = staring.split("|-|");
                let categoriesSplit = categories.split("|-|");
                const response = await MoviesServices.updateMovie(id, title, synopsis, image, staringSplit, release_date, length, categoriesSplit);
                return res.send(response);
            } catch (err) {
                throw err;
            }
        }
    }

    deleteMovie(){
        return async(req, res) => {
            const id = req.params.id;
            const response = await MoviesServices.deleteMovie(id);
            res.send(response);
        }
    }
}

module.exports = new MoviesControllers();