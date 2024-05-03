import mongoose from mongoose;

const ratingSchema = new mongoose.Schema({
    Rating: {
        type: Number, required: true
    },
    User: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User'
    },
    Service: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Service'
    },
    Review: {
        type: String
    }
}, { timestamps: true }
);

export const Rating = mongoose.model('Rating', ratingSchema)