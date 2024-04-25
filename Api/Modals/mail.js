import mongoose from "mongoose";

const mailSchema = new mongoose.Schema({
    Email: [{
        type: String,
        required: true,
    }],
    Body: {
        type: String,
        required: true,
    },
}, { timestamps: true });

export const Mail = mongoose.model('Mail', mailSchema);
