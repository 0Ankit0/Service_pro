import mongoose from "mongoose";

const chatGroupSchema = new mongoose.Schema({
    Name: {
        type: String,
        required: true
    },
    Members: [{
        type: mongoose.Schema.Types.ObjectId,
        ref: "User"
    }],
    Active: { type: Boolean, default: true }
}, { timestamps: true });

export const ChatGroup = mongoose.model("ChatGroup", chatGroupSchema);