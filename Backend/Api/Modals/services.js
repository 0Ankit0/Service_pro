import mongoose from "mongoose";

const serviceSchema = new mongoose.Schema({
    Name: { type: String, required: true },
    Description: { type: String },
    Price: { type: Number, required: true },
    Duration: { type: String, required: true },
}, { timestamps: true }
)
export const Service = mongoose.model('Service', serviceSchema)