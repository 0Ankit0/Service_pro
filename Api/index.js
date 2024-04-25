import * as dotenv from 'dotenv';
import http from 'http';
import jwt from 'jsonwebtoken';
import { Message } from './Modals/message.js';
import { User } from './Modals/users.js';
import { Server } from 'socket.io';
dotenv.config();

import app from "./Routes/route.js"
import Connect from "./Utils/Connection.js"

let io, userSocketMap, SocketMap;
try {
    const db = await Connect();

    // Create an HTTP server
    const server = http.createServer(app);

    // Initialize Socket.IO
    io = new Server(server, {
        cors: {
            origin: "*", // Allow all origins
            methods: ["*"] // Allow all methods
        }
    });

    userSocketMap = new Map(); // Map to store user ID to socket ID mapping
    SocketMap = new Map(); // Map to store socket ID to user ID mapping
    io.on('connection', (socket) => {

        try {
            const token = socket.handshake.query.token;
            const user = jwt.verify(token, process.env.JWTSecret);
            const userId = user.id;
            userSocketMap.set(socket.id, { socketId: socket.id, userId }); // Store the user ID and socket ID
            SocketMap.set(userId, socket.id);

            // socket.emit('loginSuccessful');
        } catch (error) {
            console.log('Error verifying JWT:', error);
        }


        socket.on('message', async (data) => {
            try {
                const { receiverId, message } = data;

                const senderSocket = userSocketMap.get(socket.id);
                if (SocketMap.get(receiverId)) {
                    await Message.create({
                        message: message,
                        sender: senderSocket.userId,
                        receiver: receiverId
                    });
                    socket.to(SocketMap.get(receiverId)).emit('liveMessage', message);
                } else {
                    const DbResponse = await Message.create({
                        message: message,
                        sender: senderSocket.userId,
                        receiver: receiverId
                    });
                }
                socket.emit('messageSent', message);
            } catch (error) {
                console.log('Error handling message:', error);
            }
        });


        socket.on('disconnect', () => {
            const res = User.findByIdAndUpdate(userSocketMap.get(socket.id).userId, { LastActive: new Date() });
            userSocketMap.delete(socket.id);
        });


    });

    server.listen(process.env.PORT, () => {
        console.log(`listening on port ${process.env.PORT}`)
    })
} catch (err) {
    console.log(err);
}

export { io, userSocketMap, SocketMap };