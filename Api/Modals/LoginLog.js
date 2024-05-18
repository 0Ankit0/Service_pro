import mongoose from "mongoose";


const loginLogSchema = new mongoose.Schema({
    Token: {
        type: String,
        required: true,
    },
    UserId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "User",
        required: true,
    },
    Name: {
        type: String,
        required: true,
    },
    loginTime: {
        type: Date,
        required: true,
    },
    logoutTime: {
        type: Date,
    },
    ipAddress: {
        type: String,
        required: true,
    },
    Machine: {
        type: String,
        required: true,
    },

}, { timestamps: true });

export const LoginLog = mongoose.model("LoginLog", loginLogSchema);
