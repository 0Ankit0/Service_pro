import { Router } from "express";
import express from "express";
import multer from "multer";
import fs from "fs";
import path from "path";
import { fileURLToPath } from "url";
import { dirname } from "path";

const uploadRouter = Router();
const __dirname = dirname(fileURLToPath(import.meta.url));
const uploadsDir = path.join(__dirname, "../uploads");
const publicBaseUrl = (process.env.PUBLIC_BASE_URL || `http://localhost:${process.env.PORT || 8000}`).replace(/\/$/, "");

uploadRouter.get("/", async (req, res) => {
  //this is /upload/index page
  try {
    const fileUrls = fs
      .readdirSync(uploadsDir)
      .map((file) => `${publicBaseUrl}/uploads/${file}`);
    res.status(200).send({ files: fileUrls.join(", ") });
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, "uploads/");
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

uploadRouter.post("/file", upload.single("file"), (req, res) => {
  try {
    const fileUrl = req.file.path;

    res.status(200).send(`${publicBaseUrl}/${fileUrl}`);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

uploadRouter.post("/files", upload.array("files"), (req, res) => {
  try {
    const fileUrls = req.files.map((file) => file.path);

    res
      .status(200)
      .send(`Files uploaded successfully. File URLs: ${fileUrls.join(", ")}`);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});
export default uploadRouter;
