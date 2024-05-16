import mongoose from "mongoose";

const messageSchema = new mongoose.Schema({
    message: {
        required: true,
        type: String
    },
    sender: {
        required: true,
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User'
    },
    receiver: {
        required: true,
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User'
    },
    Active: { type: Boolean, default: true }
}, {
    timestamps: true
});

export const Message = mongoose.model("Message", messageSchema);