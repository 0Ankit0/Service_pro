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
    const fileUrls = fs.readdirSync(uploadsDir).map(file => `http://localhost:8000/uploads/${file}`);
    res.status(200).send(`List of stored files: ${fileUrls.join(", ")}`);
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

uploadRouter.post("/file", upload.single("file"), (req, res) => {
    // File has been uploaded and saved in the "uploads" folder
    const fileUrl = req.file.path;
    res.status(200).send(`${fileUrl}`);
});
uploadRouter.post("/files", upload.array("files"), (req, res) => {
    // Files have been uploaded and saved in the "uploads" folder 
    const fileUrls = req.files.map(file => file.path);
    res.status(200).send(`Files uploaded successfully. File URLs: ${fileUrls.join(", ")}`);
});

export default uploadRouter;