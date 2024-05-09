import { Router } from "express";
import express from "express";
import multer from "multer";
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import { dirname } from 'path';


const uploadRouter = Router();
var router = express();
const __dirname = dirname(fileURLToPath(import.meta.url));
const uploadsDir = path.join(__dirname, 'uploads');

router.get('/', async (req, res) => { //this is /upload/index page
    try {

        const fileUrls = fs.readdirSync(uploadsDir).map(file => `http://localhost:8000/uploads/${file}`);
        res.status(200).send(`List of stored files: ${fileUrls.join(", ")}`);
    } catch (error) {
        res.status(400).json({ message: "Error occurred" });
    }
});;


const storage = multer.diskStorage({
    destination: function (req, file, cb) {
        cb(null, "uploads/");
    },
    filename: function (req, file, cb) {
        cb(null, file.originalname);
    },
});

const upload = multer({ storage: storage });

export const userFiles = new Map(); // This map will store the token and the corresponding files

uploadRouter.post("/file", upload.single("file"), (req, res) => {
    try {
        const fileUrl = req.file.path;
        const token = req.headers.authorization;

        // If the token is not in the map, add it with an empty array
        if (!userFiles.has(token)) {
            userFiles.set(token, []);
        }

        // Add the file to the array of files for this token
        userFiles.get(token).push(fileUrl);

        res.status(200).send(`${fileUrl}`);
    } catch (error) {
        res.status(400).json({ message: "Error occurred" });
    }
});

uploadRouter.post("/files", upload.array("files"), (req, res) => {
    try {
        const fileUrls = req.files.map(file => file.path);
        const token = req.headers.authorization;

        // If the token is not in the map, add it with an empty array
        if (!userFiles.has(token)) {
            userFiles.set(token, []);
        }

        // Add the files to the array of files for this token
        userFiles.get(token).push(...fileUrls);

        res.status(200).send(`Files uploaded successfully. File URLs: ${fileUrls.join(", ")}`);
    } catch (error) {
        res.status(400).json({ message: "Error occurred" });
    }
});
export default uploadRouter;