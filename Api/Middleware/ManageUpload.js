import express from "express";
import multer from "multer";
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import { dirname } from 'path';
import { userFiles } from '../Routes/uploadRoute.js';


var router = express();
const __dirname = dirname(fileURLToPath(import.meta.url));
const uploadsDir = path.join(__dirname, 'uploads');


export const removeTempFiles = (req, res, next) => {
    const token = req.headers.authorization;
    const fileName = req.body.fileName;

    if (userFiles.has(token)) {
        let files = userFiles.get(token);
        files = files.filter(file => path.basename(file) === fileName);

        // Delete the files not matching the provided file name
        userFiles.get(token).forEach(file => {
            if (path.basename(file) !== fileName) {
                fs.unlinkSync(file);
            }
        });
        // Empty the set for this token
        userFiles.set(token, []);
    }
    next();
}