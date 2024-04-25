import mongoose from "mongoose";
const userSchema = new mongoose.Schema({
    Name: { type: String, required: true },
    Email: { type: String, required: true, unique: true },
    Password: { type: String, required: true },
    PhoneNo: { type: Number, required: true },
    Address: { type: String, required: true },
    Role: { type: String, default: 'user' },
    LastActive: { type: Date, default: Date.now },
}, { timestamps: true }
)
export const User = mongoose.model('User', userSchema)