import mongoose from "mongoose";

const serviceSchema = new mongoose.Schema({
    Name: { type: String, required: true },
    Description: { type: String },
    Price: { type: Number },
    Duration: { type: String },
}, { timestamps: true }
)
export const Service = mongoose.model('Service', serviceSchema)