import mongoose from "mongoose";

const serviceSchema = new mongoose.Schema({
    Name: { type: String, required: true },
    Description: { type: String },
    Price: { type: Number },
    Duration: { type: String },
    Image: { type: String },
    Active: { type: Boolean, default: true }
}, { timestamps: true }
)

serviceSchema.index({ Name: 'text' });

export const Service = mongoose.model('Service', serviceSchema)