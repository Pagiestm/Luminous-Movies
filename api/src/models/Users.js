const mongoose = require("mongoose");

const Users = mongoose.model('Users', {
    pseudo: {type: String, required: true},
    email: {type: String, required: true},
    password: {type: String, required: true}
});

module.exports = Users;