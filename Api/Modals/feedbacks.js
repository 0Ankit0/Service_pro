import mongoose from "mongoose";

const feedbackSchema = new mongoose.Schema({
    UserId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
        required: true
    },
    ServiceId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Service',
        required: true
    },
    Rating: { type: Number, required: true },
    Comment: { type: String, required: true },
}, { timestamps: true }
)
export const Feedback = mongoose.model('Feedback', feedbackSchema)