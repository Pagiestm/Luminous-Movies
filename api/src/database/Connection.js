const mongoose = require("mongoose");

const Connection = () => {
    try {
        mongoose.connect(process.env.MONGO_URL);
        console.log("base de données connectée");
    } catch (error) {
        throw error;
    }
}

module.exports = Connection;