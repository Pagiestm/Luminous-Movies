const CategoriesServices = require("../services/CategoriesServices");

class CategoriesControllers{
    getCategories(){
        return async (req, res) => {
            const response = await CategoriesServices.getCategories();
            res.send(response); 
        }
    }

    getCategorieById(){
        return async (req, res) => {
            const id = req.params.id;
            const response = await CategoriesServices.getCategorieById(id);
            res.send(response); 
        }
    }

    getCategorieByName(){
        return async (req, res) => {
            const name = req.params.name;
            const response = await CategoriesServices.getCategorieByName(name);
            res.send(response);
        }
    }

    addCategorie(){
        return async (req, res) => {
            const name = req.body.name;
            if (name == null) {
                return res.send({error: "Données manquante"});
            }

            const occurence = await CategoriesServices.getCategorieByName(name);
            if (occurence != null) {
                return res.send({error: "Nom de catégorie déjà pris"});
            }
            try {
                const response = await CategoriesServices.addCategorie(name);
                return res.send(response);
            } catch (err) {
                throw err;
            }
        }
    }

    updateCategorie(){
        return async (req, res) => {
            const id = req.params.id;
            const name = req.body.name;
            const response = await CategoriesServices.updateCategorie(id, name);
            res.send(response);
        }
    }

    deleteCategorie(){
        return async(req, res) => {
            const id = req.params.id;
            const response = await CategoriesServices.deleteCategorie(id);
            res.send(response);
        }
    }
}

module.exports = new CategoriesControllers();