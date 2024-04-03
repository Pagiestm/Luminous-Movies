const usersServices = require("../services/UsersServices");
const bcrypt = require("bcrypt");

class UsersControllers{
    getUsers(){
        return async (req, res) => {
            const response = await usersServices.getUsers();
            res.send(response); 
        }
    }

    getUserById(){
        return async (req, res) => {
            const id = req.params.id;
            const response = await usersServices.getUserById(id);
            res.send(response); 
        }
    }

    addUser(){
        return async (req, res) => {
            const pseudo = req.body.pseudo;
            const email = req.body.email;
            const password = req.body.email;
            if (email == null || pseudo == null || password == null) {
                return res.send({error: "Données manquante"});
            }

            const occurence = await usersServices.getUserByEmail(email);
            if (occurence != null) {
                return res.send({error: "Email déjà pris"});
            }

            bcrypt.hash(password, 10, async function(err, hash) {
                if (!err) {
                    const response = await usersServices.addUser(pseudo, hash, email);
                    return res.send(response);
                }else{
                    throw err;
                }
            });
        }
    }

    updateUser(){
        return async (req, res) => {
            const id = req.params.id;
            const pseudo = req.body.pseudo;
            const response = await usersServices.updateUser(id, pseudo);
            res.send(response);
        }
    }

    deleteUser(){
        return async(req, res) => {
            const id = req.params.id;
            const response = await usersServices.deleteUser(id);
            res.send(response);
        }
    }
}

module.exports = new UsersControllers();