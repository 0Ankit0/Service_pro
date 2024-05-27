import mongoose from "mongoose";

const CodeSchema = new mongoose.Schema({
    code: {
        type: String,
        required: true
    },
    date: {
        type: Date,
        default: Date.now
    },
    email: {
        type: String,
        required: true
    },
    type: {
        type: String,
        required: true
    },
    isUsed: {
        type: Boolean,
        default: false
    },
    usedDate: {
        type: Date
    },
    usedBy: {
        type: String
    },
    usedByEmail: {
        type: String
    }
});
CodeSchema.methods.isExpired = function () {
    const now = new Date();
    const fiveMinutesLater = new Date(this.date.getTime() + 5 * 60 * 1000);
    return now > fiveMinutesLater;
};

const CodeLog = mongoose.model('CodeLog', CodeSchema);


const generateUniqueCode = async () => {
    let code;
    let codeExists = true;

    while (codeExists) {
        code = Math.floor(100000 + Math.random() * 900000).toString();
        codeExists = await Code.findOne({ code });
    }

    return code;
};

export { CodeLog, generateUniqueCode };