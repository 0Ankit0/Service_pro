import mongoose from "mongoose";
const userSchema = new mongoose.Schema({
    Name: {
        type: String, required: true
    },
    Email: {
        type: String, required: true, unique: true
    },
    Password: {
        type: String, required: true
    },
    PhoneNo: {
        type: Number, required: true
    },
    Address: {
        type: String, required: true
    },
    Role: {
        type: String,
        enum: ['user', 'provider', 'admin'],
        default: 'user'
    },
    ProfileImg: {
        type: String
    },
    Documents: [{
        type: String
    }],
    Verified: {
        type: Boolean, default: false
    },
    Active: {
        type: Boolean, default: true
    },
    Services: [{
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Service'
    }],
    ServiceAnalytics: {
        TotalServices: {
            type: Number, default: 0
        },
        CompletedServices: {
            type: Number, default: 0
        },
    }
}, { timestamps: true }
)
//to create text index for search using name
userSchema.index({ Name: 'text' });
export const User = mongoose.model('User', userSchema)