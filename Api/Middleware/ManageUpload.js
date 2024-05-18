import fs from 'fs/promises';
import path from 'path';

export const removeTempFiles = async (req, res, next) => {
    const fileName = req.body.fileName;
    const userId = req.user.id;
    const userDir = path.resolve(__dirname, "uploads", userId);
    const uploadsDir = path.resolve(__dirname, "uploads");

    try {
        // Check if the directory exists
        await fs.access(userDir);

        const files = await fs.readdir(userDir);

        // Handle all file deletions concurrently
        await Promise.all(files.map(async (file) => {
            const filePath = path.resolve(userDir, file);

            if (file !== fileName) {
                // Delete the file
                await fs.unlink(filePath);
            } else {
                // Move the file to the uploads directory
                const newFilePath = path.resolve(uploadsDir, file);
                await fs.rename(filePath, newFilePath);
            }
        }));

        next();
    } catch (error) {
        console.error(`Error occurred: ${error}`);
        res.status(400).json({ message: "Error occurred" });
    }
};