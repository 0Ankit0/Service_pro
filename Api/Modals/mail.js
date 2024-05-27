import mongoose from "mongoose";

const mailSchema = new mongoose.Schema({
    Email: [{
        type: String,
        required: true,
    }],
    Body: {
        type: String,
        required: true,
    },
    Code: {
        type: String,
    },
    Name: { type: string }
}, { timestamps: true });
mailSchema.methods.isExpired = function () {
    const now = new Date();
    const fiveMinutesLater = new Date(this.date.getTime() + 5 * 60 * 1000);
    return now > fiveMinutesLater;
};

const generateUniqueCode = async () => {
    let code;
    let codeExists = true;

    while (codeExists) {
        code = Math.floor(100000 + Math.random() * 900000).toString();
        codeExists = await Code.findOne({ code });
    }

    return code;
};
const Mail = mongoose.model('Mail', mailSchema);
export { Mail, generateUniqueCode };
