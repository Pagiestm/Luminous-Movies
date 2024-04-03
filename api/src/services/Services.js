const Connection = require("../database/Connection");

class Services {
    constructor(){
        try {
            Connection();
        } catch (error) {
            console.error("erreur de connexion à la base de données");
        }
    }
}

module.exports = Services;