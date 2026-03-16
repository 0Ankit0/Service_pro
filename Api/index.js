import * as dotenv from "dotenv";
import http from "http";
import jwt from "jsonwebtoken";
import { Message } from "./Modals/message.js";
import { User } from "./Modals/users.js";
import { Server } from "socket.io";

dotenv.config();

import app from "./Routes/route.js";
import Connect from "./Utils/Connection.js";

let io;
const userSocketMap = new Map();
const SocketMap = new Map();

try {
  await Connect();

  const server = http.createServer(app);

  io = new Server(server, {
    cors: {
      origin: "*",
      methods: ["*"],
    },
  });

  io.on("connection", (socket) => {
    let userId;

    try {
      const token = socket.handshake.query.token;
      const user = jwt.verify(token, process.env.JWTSecret);
      userId = user.id;

      userSocketMap.set(socket.id, { socketId: socket.id, userId });
      SocketMap.set(userId, socket.id);
    } catch (error) {
      console.log("Error verifying JWT:", error.message);
      socket.disconnect(true);
      return;
    }

    socket.on("message", async (data) => {
      try {
        const { receiverId, message } = data;

        if (!receiverId || !message?.trim()) {
          return socket.emit("messageError", "Invalid message payload");
        }

        const senderSocket = userSocketMap.get(socket.id);

        await Message.create({
          message,
          sender: senderSocket.userId,
          receiver: receiverId,
        });

        if (SocketMap.get(receiverId)) {
          socket.to(SocketMap.get(receiverId)).emit("liveMessage", message);
        }

        socket.emit("messageSent", message);
      } catch (error) {
        console.log("Error handling message:", error);
        socket.emit("messageError", "Failed to send message");
      }
    });

    socket.on("disconnect", async () => {
      const socketData = userSocketMap.get(socket.id);
      if (!socketData) return;

      await User.findByIdAndUpdate(socketData.userId, { LastActive: new Date() });
      SocketMap.delete(socketData.userId);
      userSocketMap.delete(socket.id);
    });
  });

  const port = process.env.PORT || 8000;
  const host = process.env.HOST || "0.0.0.0";

  server.listen(port, host, () => {
    console.log(`listening on ${host}:${port}`);
  });
} catch (err) {
  console.log(err);
}

export { io, userSocketMap, SocketMap };
