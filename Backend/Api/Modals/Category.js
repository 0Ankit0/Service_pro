import mongoose from 'mongoose';

const CategorySchema = new mongoose.Schema({
    Name: {
        type: String,
        required: true,
        unique: true
    },
    Description: {
        type: String
    },
    Services: [{
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Service'
    }],
    Image: {
        type: String
    }
}, { timestamps: true });

export const Category = mongoose.model('Category', CategorySchema);