import { Router } from "express";
import { User } from "../Modals/users.js";
import { createJWT, hashPassword, comparePassword } from "../Middleware/auth.js";
import rateLimit from "express-rate-limit";

const userRouter = Router();

const limiter = rateLimit({
    windowMs: 15 * 60 * 1000, // 15 minutes
    max: 5, // limit each IP to 5 requests per windowMs
    handler: function (req, res, /*next*/) {
        const retryAfter = Math.ceil(res.getHeaders()['retry-after'] / 60); // Get the Retry-After header and convert it to minutes
        res.status(429).json({
            message: `Too many password retries, please try again after ${retryAfter} minutes`,
        });
    }
});

userRouter.get('/', async (req, res) => { //this is /user/index page
    var users = await User.find({}).lean().exec();
    res.json(users);
});

userRouter.post('/login', limiter, async (req, res) => {
    try {
        const user = await User.findOne({ Email: req.body.Email }).exec();
        const isValid = await comparePassword(user.Password, req.body.Password);
        if (!isValid) return res.status(status(401)).json({ message: "Invalid password" });
        const token = createJWT(user);
        res.status(200).json({ token: token, message: "Success" });
    } catch (error) {
        console.log(error);
        res.status(401).json({ token: "", message: "Error occurred" })
    }
});

userRouter.post('/signup', async (req, res) => {
    try {
        const hash = await hashPassword(req.body.Password);
        const user = await User.create({ ...req.body, Password: hash });
        res.json(user);
    } catch (error) {
        res.json({ message: "Duplicate email" })
    }
});

export default userRouter;
