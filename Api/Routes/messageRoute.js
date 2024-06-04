import { Router } from "express";
import { Message } from "../Modals/message.js";
import { User } from "../Modals/users.js";
import { SocketMap } from "../index.js";

const messageRouter = Router();

messageRouter.get('/userList', async (req, res) => {
    try {

        var users = await User.find({ _id: { $ne: req.user.id } }).lean().exec();

        users.forEach(user => {
            user.status = SocketMap.has(user._id.toString()) ? 'online' : 'offline';
        });
        res.status(200).json({ message: "User List", users });
    } catch (error) {
        res.status(400).json({ message: error.message });

    }
});
messageRouter.post('/', async (req, res) => { //this is /message/index page
    try {

        const messages = await Message.find({
            $or: [
                { sender: req.user.id, receiver: req.body.receiver },
                { sender: req.body.receiver, receiver: req.user.id }
            ]
        }).lean().exec();
        messages.forEach(message => {
            message.status = (message.sender.toString() === req.user.id.toString()) ? 'sender' : 'receiver'
        })
        res.status(200).json({ message: "Messages fetched successfully", data: messages });
    } catch (error) {
        res.status(400).json({ error: error.message });
    }
});





export default messageRouter;
