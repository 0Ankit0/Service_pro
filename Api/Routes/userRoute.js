import { Router } from "express";
import { User } from "../Modals/users.js";
import {
  createJWT,
  hashPassword,
  comparePassword,
  protect,
  enforceRole,
} from "../Middleware/auth.js";
import rateLimit from "express-rate-limit";
import { LoginLog } from "../Modals/LoginLog.js";
import mongoose from "mongoose";

const userRouter = Router();

const limiter = rateLimit({
  windowMs: 1 * 60 * 1000, // 1 minute
  max: 3, // limit each IP to 5 requests per windowMs
  handler: function (req, res /*next*/) {
    const retryAfter = Math.ceil(res.getHeaders()["retry-after"] / 60); // Get the Retry-After header and convert it to minutes
    res.status(429).json({
      message: `Too many password retries, please try again after ${retryAfter} minutes`,
    });
  },
});

userRouter.post("/login", limiter, async (req, res) => {
  try {
    const user = await User.findOne({ Email: req.body.Email }).exec();
    const isValid = await comparePassword(user.Password, req.body.Password);
    if (!isValid) return res.status(401).json({ message: "Invalid password" });
    const token = createJWT(user);

    await LoginLog.create({
      Token: token,
      loginTime: new Date(),
      ipAddress: req.ip,
      Machine: req.headers["user-agent"],
      UserId: user._id,
      Name: user.Name,
    });

    res.status(200).json({
      message: "Success",
      data: {
        token: token,
        Role: user.Role,
        Verified: user.Verified,
        Active: user.Active,
      },
    });
  } catch (error) {
    console.log(error);
    res.status(400).json({ token: "", message: error.message });
  }
});

userRouter.post("/signup", async (req, res) => {
  try {
    const hash = await hashPassword(req.body.Password);
    const user = await User.create({ ...req.body, Password: hash });
    res.status(200).json({ data: user, message: "User created successfully" });
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

userRouter.get("/profile", protect, async (req, res) => {
  try {
    const user = await User.findById(req.user.id).lean().exec();
    res.status(200).json({ data: user, message: "User fetched successfully" });
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

userRouter.put("/profile", protect, async (req, res) => {
  try {
    const user = await User.findByIdAndUpdate(req.user.id, req.body, {
      new: true,
    });
    res.status(200).json({ message: "User updated successfully", data: user });
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

userRouter.get("/verifyAccount", async (req, res) => {
  try {
    await User.findByIdAndUpdate(req.query.id, { Verified: true });
    res.status(200).send(
      `<!DOCTYPE html>
            <html>
              <head>
                <title>Account Verified</title>
                <style>
                  body{
              padding: 25px;
            }
            .title {
                color: #5C6AC4;
            }
                </style>
              </head>
              <body>
                  <h1 class="title">Your Account Has been Verified Successfully</h1>
                  <p id="currentTime"></p>
                  <script type="text/javascript">
                    function showTime() {
                document.getElementById('currentTime').innerHTML = new Date().toUTCString();
            }
            showTime();
            setInterval(function () {
                showTime();
            }, 1000);
                  </script>
              </body>
            </html>`
    );
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

function makeRandomString(length) {
  let result = "";
  const characters =
    "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
  const charactersLength = characters.length;
  for (let i = 0; i < length; i++) {
    result += characters.charAt(Math.floor(Math.random() * charactersLength));
  }
  return result;
}

userRouter.get("/resetPassword", async (req, res) => {
  try {
    var randomPassword = makeRandomString(6);
    const hash = await hashPassword(randomPassword);
    await User.findByIdAndUpdate(req.query.id, { Password: hash });
    res.status(200).send(
      `<!DOCTYPE html>
            <html>
              <head>
                <title>Password Changed</title>
                <style>
                  body{
              padding: 25px;
            }
            .title {
                color: #5C6AC4;
            }
                </style>
              </head>
              <body>
                  <h2 class="title">Your Password has been reset successfully.Your new password is</h2>
                  <h1 class="title">${randomPassword}</h1>
                  <p id="currentTime"></p>
                  <script type="text/javascript">
                    function showTime() {
                document.getElementById('currentTime').innerHTML = new Date().toUTCString();
            }
            showTime();
            setInterval(function () {
                showTime();
            }, 1000);
                  </script>
              </body>
            </html>`
    );
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

userRouter.delete("/profile", protect, async (req, res) => {
  try {
    await User.findByIdAndUpdate(req.user.id, { Active: 0 });
    res.status(200).json({ message: "User deleted successfully" });
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

userRouter.delete(
  "/delete/:id",
  protect,
  enforceRole("admin"),
  async (req, res) => {
    try {
      await User.findByIdAndDelete(req.params.id, { Active: false });
      res.status(200).json({ message: "User deleted successfully" });
    } catch (error) {
      res.status(400).json({ message: error.message });
    }
  }
);

userRouter.get("/service/:serviceId", async (req, res) => {
  try {
    const users = await User.find({ Services: { $in: req.params.serviceId } })
      .populate("Services")
      .lean()
      .exec();
    res.status(200).json({ message: "User fetched successfully", data: users });
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

userRouter.get("/search/:userName", async (req, res) => {
  try {
    const users = await User.find({ $text: { $search: req.params.userName } })
      .lean()
      .exec();
    res
      .status(200)
      .json({ message: "Users fetched successfully", data: users });
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

userRouter.get(
  "/activate/:userId",
  protect,
  enforceRole("admin"),
  async (req, res) => {
    try {
      await User.findByIdAndUpdate(req.params.userId, { Active: 1 });
      res.status(200).json({ message: "User activated successfully" });
    } catch (error) {
      res.status(400).json({ message: error.message });
    }
  }
);

userRouter.post("/logout", protect, async (req, res) => {
  try {
    const token = req.headers.authorization.split(" ")[1];
    await LoginLog.updateOne(
      { Token: token, logoutTime: null },
      { logoutTime: new Date() }
    );
    res.status(200).json({ message: "User logged out successfully" });
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

userRouter.post("/changePassword", protect, async (req, res) => {
  try {
    const user = await User.findById(req.user.id).exec();
    const isValid = await comparePassword(user.Password, req.body.OldPassword);
    if (!isValid) return res.status(401).json({ message: "Invalid password" });
    const hash = await hashPassword(req.body.NewPassword);
    await User.findByIdAndUpdate(req.user.id, { Password: hash });
    res.status(200).json({ message: "Password changed successfully" });
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

export default userRouter;
