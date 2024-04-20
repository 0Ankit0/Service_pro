import mongoose from 'mongoose';

const CategorySchema = new mongoose.Schema({
    name: {
        type: String,
        required: true,
        unique: true
    },
    description: {
        type: String
    },
    Services: [{
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Service'
    }],
    image: {
        type: String
    }
}, { timestamps: true });

const Category = mongoose.model('Category', CategorySchema);