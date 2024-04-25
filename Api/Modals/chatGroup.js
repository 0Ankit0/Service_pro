import mongoose from "mongoose";

const chatGroupSchema = new mongoose.Schema({
    Name: {
        type: String,
        required: true
    },
    Members: [{
        type: mongoose.Schema.Types.ObjectId,
        ref: "User"
    }]
}, { timestamps: true });

export const ChatGroup = mongoose.model("ChatGroup", chatGroupSchema);