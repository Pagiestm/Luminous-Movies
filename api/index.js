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
const CategoriesRouter = require("./src/routers/CategoriesRouter");
const MoviesRouter = require("./src/routers/MoviesRouter");
const FavoritesRouter = require("./src/routers/FavoritesRouter");
const RatingsRouter = require("./src/routers/RatingsRouter");
app.use('/users', UsersRouter);
app.use('/categories', CategoriesRouter);
app.use('/movies', MoviesRouter);
app.use('/favorites', FavoritesRouter);
app.use('/ratings', RatingsRouter);

// create server
const server = http.createServer(app);

// start server
server.listen(3000, ()=>console.log("serveur a démarré"));
