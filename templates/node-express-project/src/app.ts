import express, { Application, Request, Response } from "express";
import expressLayouts from 'express-ejs-layouts';
import http from "http";
import path from "path";
import url from 'url';

import debug from "./config/debug";

const __filename = url.fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);


const app: Application = express();

// EJS setup
app.use(expressLayouts);

// Serve static / public files
const publicDirectoryPath = path.join(__dirname, "./public");
app.use(express.static(publicDirectoryPath));

// Setting the root path for views directory
app.set('views', path.join(__dirname, 'views'));

// Setting the view engine
app.set('view engine', 'ejs');

/* Home route */
app.get("/", (req: Request, res: Response) => {
	res.render("index")
});


const server: http.Server = http.createServer(app);

// Setting the port
const port = debug.PORT;

// Starting the server
server.listen(port, () => {
    console.log(`SERVER RUNNING ON http://localhost:${port} (${process.env.NODE_ENV})`);
});
