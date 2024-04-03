const mongoose = require("mongoose");

const Connection = () => {
    mongoose.connect(process.env.MONGO_URL);
    console.log("base de données connectée");
}

module.exports = Connection;