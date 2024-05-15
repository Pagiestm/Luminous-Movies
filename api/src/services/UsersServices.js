const Users = require('../models/Users');
const Services = require('./Services');

class UsersServices extends Services {
    async getUsers(){
        try {
            const users = await Users.find(); 
            return users;
        } catch (error) {
            throw error;
        }
    }

    async getUserById(id){
        try {
            const user = await Users.findOne({_id: id});
            return user;
        } catch (error) {
            throw error;
        }
    }

    async getUserByEmail(email){
        try {
            const user = await Users.findOne({email: email});
            return user;
        } catch (error) {
            throw error;
        }
    }
    
    async addUser(pseudo, password, email){
        try {
            const user = new Users({
                pseudo: pseudo,
                password: password,
                email: email,
                role: "user"
            });
            await user.save();
            return user;
        } catch (error) {
            throw error;
        }
    }

    async updateUser(id, pseudo, email){
        try {
            const user = await Users.findOneAndUpdate({_id: id}, {pseudo: pseudo, email: email});
            return user;
        } catch (error) {
            throw error;
        }
    }

    async deleteUser(id){
        try {
            const user = await Users.findByIdAndDelete({_id: id});
            return user;
        } catch (error) {
            throw error;
        }
    }
}

module.exports = new UsersServices();