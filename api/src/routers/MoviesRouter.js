const express = require("express");
const MoviesController = require("../controllers/MoviesController");
const router = express.Router();

// L'app peut lister l’ensemble des films
router.get("/", MoviesController.getMovies());

// L'app peut récupérer les informations des films via son titre
router.get("/title/:title", MoviesController.getMoviesByTitle());

// L'app peut récupérer les informations des films via la catégorie
router.get("/categorie/:categorie", MoviesController.getMoviesByCategorie());

// L'app peut récupérer les informations d’un film via son id
router.get("/:id", MoviesController.getMovieById());

// L'app peut ajouter un film
router.post("", MoviesController.addMovie());

// L'app peut modifier les informations d’un film
router.put("/:id", MoviesController.updateMovie());

// L'app peut supprimer un film
router.delete("/:id", MoviesController.deleteMovie());

module.exports = router