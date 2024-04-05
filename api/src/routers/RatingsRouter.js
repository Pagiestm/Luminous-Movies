const express = require("express");
const RatingsController = require("../controllers/RatingsController");
const router = express.Router();

// L'app peut lister l’ensemble des notes
router.get("/", RatingsController.getRatings());

// L'app peut lister l’ensemble des notes via un film
router.get("/movie/:id", RatingsController.getRatingsByMovie());

// L'app peut lister l’ensemble des notes via un utilisateur
router.get("/user/:id", RatingsController.getRatingsByUser());

// L'app peut récupérer les informations d’une note via son id
router.get("/:id", RatingsController.getRatingById());

// L'app peut ajouter une note
router.post("", RatingsController.addRating());

// L'app peut modifier une note
router.put("/:id", RatingsController.updateRating());

// L'app peut supprimer une note
router.delete("/:id", RatingsController.deleteRating());

module.exports = router