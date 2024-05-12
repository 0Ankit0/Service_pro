import { Router } from "express";
import { User } from "../Modals/users.js";
import { createJWT, hashPassword, comparePassword, protect } from "../Middleware/auth.js";
import rateLimit from "express-rate-limit";
import { LoginLog } from "../Modals/LoginLog.js";
import mongoose from "mongoose";

const userRouter = Router();

const limiter = rateLimit({
    windowMs: 1 * 60 * 1000, // 1 minute
    max: 5, // limit each IP to 5 requests per windowMs
    handler: function (req, res, /*next*/) {
        const retryAfter = Math.ceil(res.getHeaders()['retry-after'] / 60); // Get the Retry-After header and convert it to minutes
        res.status(429).json({
            message: `Too many password retries, please try again after ${retryAfter} minutes`,
        });
    }
});

userRouter.post('/login', limiter, async (req, res) => {
    try {
        const user = await User.findOne({ Email: req.body.Email }).exec();
        const isValid = await comparePassword(user.Password, req.body.Password);
        if (!isValid) return res.status(401).json({ message: "Invalid password" });
        const token = createJWT(user);

        await LoginLog.create({ userId: user._id, loginTime: new Date(), ipAddress: req.ip, Machine: req.headers['user-agent'] });

        res.status(200).json({ message: "Success", data: { token: token, Role: user.Role } });
    } catch (error) {
        console.log(error);
        res.status(400).json({ token: "", message: error.message })
    }
});

userRouter.post('/signup', async (req, res) => {
    try {
        const hash = await hashPassword(req.body.Password);
        const user = await User.create({ ...req.body, Password: hash });
        res.status(200).json({ data: user, message: "User created successfully" });
    } catch (error) {
        res.status(400).json({ message: error.message })
    }
});

userRouter.get('/profile', protect, async (req, res) => {
    try {
        const user = await User.findById(req.user.id).lean().exec();
        res.status(200).json({ data: user, message: "User fetched successfully" });
    } catch (error) {
        res.status(400).json({ message: error.message })
    }
});

userRouter.put('/profile', protect, async (req, res) => {
    try {
        const user = await User.findByIdAndUpdate(req.user.id, req.body
            , { new: true });
        res.status(200).json({ message: "User updated successfully", data: user });
    } catch (error) {
        res.status(400).json({ message: error.message })
    }
});


userRouter.delete('/profile', async (req, res) => {
    try {
        await User.findByIdAndUpdate(req.user._id, { Active: 0 });
        res.status(200).json({ message: "User deleted successfully" });
    } catch (error) {
        res.status(400).json({ message: error.message })
    }
});

userRouter.get('/service/:serviceId', async (req, res) => {
    try {

        const users = await User.find({ Services: { $in: (req.params.serviceId) } }).populate('Services').lean().exec();
        res.status(200).json({ message: "User fetched successfully", data: users });
    } catch (error) {
        res.status(400).json({ message: error.message })
    }
});

userRouter.get('/search/:userName', async (req, res) => {
    try {
        const users = await User.find({ $text: { $search: req.params.userName } }).lean().exec();
        res.status(200).json({ message: "Users fetched successfully", data: users });
    } catch (error) {
        res.status(400).json({ message: error.message });
    }
});
export default userRouter;
