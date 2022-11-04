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
const publicDirectoryPath = path.join(__dirname, "../frontend/static");
app.use('/static', express.static(publicDirectoryPath));

// Setting the root path for views directory
app.set('views', path.join(__dirname, '../frontend/views'));

// Setting the view engine
app.set('view engine', 'ejs');

/* Home route */
app.get("/", (req: Request, res: Response) => {
    res.render("index")
});

app.get("/:name(index|foo|bar)", (req: Request, res: Response) => {
    var name = req.params.name;
    res.render(name);
});


const server: http.Server = http.createServer(app);

// Setting the port
const port = debug.PORT;

// Starting the server
server.listen(port, () => {
    console.log(`SERVER RUNNING ON http://localhost:${port} (${process.env.NODE_ENV})`);
});
