import mongoose from "mongoose";

const requestSchema = new mongoose.Schema({
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
    Date: { type: String, required: true },
    Time: { type: String, required: true },
    Status: { type: String, required: true },
}, { timestamps: true }
)
export const Request = mongoose.model('Request', requestSchema)