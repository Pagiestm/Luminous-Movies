const express = require("express");
const usersControllers = require("../controllers/UsersController");
const router = express.Router();

// L'app peut lister l’ensemble de ses users
router.get("/", usersControllers.getUsers());

// L'app peut récupérer les informations d’un utilisateur spécifique
router.get("/:id", usersControllers.getUserById());

// L'app peut ajouter un utilisateur
router.post("", usersControllers.addUser());

// L'app peut modifier les informations d’un utilisateur
router.put("/:id", usersControllers.updateUser());

// L'app peut supprimer les informations d’un utilisateur
router.delete("/:id", usersControllers.deleteUser());

module.exports = router