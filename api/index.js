require('dotenv').config();
const express = require("express");
const http = require("http");
const app = express();
const bodyParser = require("body-parser")
const cors = require("cors")

//middleware
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.use(cors({
    origin: '*',
    methods: 'GET,HEAD,PUT,PATCH,POST,DELETE',
    credentials: true,
}));

//routes
const UsersRouter = require("./src/routers/UsersRouter");
app.use('/users', UsersRouter);

// create server
const server = http.createServer(app);

// start server
server.listen(3000, ()=>console.log("serveur a démarré"));