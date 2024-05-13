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
    ProviderId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User'
    },
    Image: { type: String },
    Date: { type: String, required: true },
    Time: { type: String, required: true },
    Status: {
        type: String,
        enum: ['pending', 'accepted', 'completed', 'cancelled'],
        default: 'pending'
    },
}, { timestamps: true }
)
export const Request = mongoose.model('Request', requestSchema)