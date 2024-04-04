const express = require("express");
const FavoritesController = require("../controllers/FavoritesController");
const router = express.Router();

// L'app peut lister l’ensemble des favoris
router.get("/", FavoritesController.getFavorites());

// L'app peut lister l’ensemble des favoris via un film
router.get("/movie/:id", FavoritesController.getFavoritesByMovie());

// L'app peut lister l’ensemble des favoris via un utilisateur
router.get("/user/:id", FavoritesController.getFavoritesByUser());

// L'app peut récupérer les informations d’un favoris via son id
router.get("/:id", FavoritesController.getFavoriteById());

// L'app peut ajouter un favoris
router.post("", FavoritesController.addFavorite());

// L'app peut supprimer un favoris
router.delete("/:id", FavoritesController.deleteFavorite());

module.exports = router