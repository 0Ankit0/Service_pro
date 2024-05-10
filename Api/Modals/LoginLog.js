import mongoose from "mongoose";


const loginLogSchema = new mongoose.Schema({
    userId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "User",
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

const LoginLog = mongoose.model("LoginLog", loginLogSchema);

export default LoginLog;