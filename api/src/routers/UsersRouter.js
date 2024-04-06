const express = require("express");
const UsersController = require("../controllers/UsersController");
const router = express.Router();

// L'app peut lister l’ensemble de ses users
router.get("/", UsersController.getUsers());

// L'app peut récupérer les informations d’un utilisateur spécifique
router.get("/:id", UsersController.getUserById());

// L'app peut récupérer les informations d’un utilisateur spécifique via son email et mdp
router.get("/email/:email", UsersController.getUserByEmailAndPassword());

// L'app peut ajouter un utilisateur
router.post("", UsersController.addUser());

// L'app peut modifier les informations d’un utilisateur
router.put("/:id", UsersController.updateUser());

// L'app peut supprimer les informations d’un utilisateur
router.delete("/:id", UsersController.deleteUser());

module.exports = router