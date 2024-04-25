import { Router } from "express";
import { Message } from "../Modals/message.js";
import { User } from "../Modals/users.js";
import { SocketMap } from "../index.js";

const messageRouter = Router();

messageRouter.get('/userList', async (req, res) => {
    var users = await User.find({ _id: { $ne: req.user.id } }).lean().exec();

    users.forEach(user => {
        user.status = SocketMap.has(user._id.toString()) ? 'online' : 'offline';
    });
    res.json(users);
});
messageRouter.post('/', async (req, res) => { //this is /message/index page
    const messages = await Message.find({
        $or: [
            { sender: req.user.id, receiver: req.body.receiver },
            { sender: req.body.receiver, receiver: req.user.id }
        ]
    }).sort({ createdAt: 'asc' }).limit(10).lean().exec();
    messages.forEach(message => {
        message.status = (message.sender.toString() === req.user.id.toString()) ? 'sender' : 'receiver'
    })
    res.json(messages);
});





export default messageRouter;
