const Categories = require('../models/Categories');
const Services = require('./Services');

class CategoriesServices extends Services {
    async getCategories(){
        try {
            const categories = await Categories.find(); 
            return categories;
        } catch (error) {
            throw error;
        }
    }

    async getCategorieById(id){
        try {
            const categorie = await Categories.findOne({_id: id});
            return categorie;
        } catch (error) {
            throw error;
        }
    }

    async getCategorieByName(name){
        try {
            const categorie = await Categories.findOne({name: name});
            return categorie;
        } catch (error) {
            throw error;
        }
    }
    
    async addCategorie(name){
        try {
            const categorie = new Categories({
                name: name,
            });
            await categorie.save();
            return categorie;
        } catch (error) {
            throw error;
        }
    }

    async updateCategorie(id, name){
        try {
            const categorie = await Categories.findOneAndUpdate({_id: id}, {name: name});
            return categorie;
        } catch (error) {
            throw error;
        }
    }

    async deleteCategorie(id){
        try {
            const categorie = await Categories.findByIdAndDelete({_id: id});
            return categorie;
        } catch (error) {
            throw error;
        }
    }
}

module.exports = new CategoriesServices();