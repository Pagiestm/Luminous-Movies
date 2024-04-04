const express = require("express");
const CategoriesController = require("../controllers/CategoriesController");
const router = express.Router();

// L'app peut lister l’ensemble des catégories
router.get("/", CategoriesController.getCategories());

// L'app peut récupérer les informations d’une catégorie via son id
router.get("/:id", CategoriesController.getCategorieById());

// L'app peut récupérer les informations d’une catégorie via son nom
router.get("/name/:name", CategoriesController.getCategorieByName());

// L'app peut ajouter une catégorie
router.post("", CategoriesController.addCategorie());

// L'app peut modifier les informations d’une catégorie
router.put("/:id", CategoriesController.updateCategorie());

// L'app peut supprimer les informations d’un utilisateur
router.delete("/:id", CategoriesController.deleteCategorie());

module.exports = router