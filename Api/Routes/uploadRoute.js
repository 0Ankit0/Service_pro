import { Router } from "express";
import express from "express";
import multer from "multer";
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import { dirname } from 'path';
import { protect } from "../Middleware/auth";


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
        const userId = req.user.id;
        const userDir = path.join(__dirname, "uploads", userId);

        // If the directory does not exist, create it
        if (!fs.existsSync(userDir)) {
            fs.mkdirSync(userDir, { recursive: true });
        }

        cb(null, userDir);
    },
    filename: function (req, file, cb) {
        const now = Date.now();
        const originalName = file.originalname;
        const extension = path.extname(originalName);
        const baseName = path.basename(originalName, extension);
        const newName = `${baseName}-${now}${extension}`;
        cb(null, newName);
    },
});

const upload = multer({ storage: storage });


uploadRouter.post("/file", protect, upload.single("file"), (req, res) => {
    try {
        const fileUrl = req.file.path;
        res.status(200).send(`${fileUrl}`);
    } catch (error) {
        res.status(400).json({ message: "Error occurred" });
    }
});

uploadRouter.post("/files", protect, upload.array("files"), (req, res) => {
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