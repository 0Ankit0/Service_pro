import mongoose from "mongoose";

const serviceSchema = new mongoose.Schema({
    Name: { type: String, required: true },
    Description: { type: String },
    Price: { type: Number },
    Duration: { type: String },
    Image: { type: String },
}, { timestamps: true }
)

serviceSchema.index({ Name: 'text' });

export const Service = mongoose.model('Service', serviceSchema)