import express from "express";
import Cors from "cors";
import userRouter from "./userRoute.js";
import { protect } from "../Middleware/auth.js";
import uploadRouter from "./uploadRoute.js";
import mailRouter from "./mailRoute.js";
import serviceRouter from "./serviceRoute.js";
import path, { dirname } from "path";
import mongoose from "mongoose";
import { fileURLToPath } from "url";
import CategoryRouter from "./CategoryRoute.js";
import messageRouter from "./messageRoute.js";
import feedbackRouter from "./feedbackRoute.js";
import requestRouter from "./requestRoute.js";
import {
  apiLimiter,
  corsOptions,
  errorHandler,
  notFoundHandler,
  securityHeaders,
} from "../Middleware/security.js";

const app = express();

app.use(Cors(corsOptions));
app.use(express.json({ limit: process.env.JSON_BODY_LIMIT || "1mb" }));
app.use(express.urlencoded({ extended: false, limit: process.env.JSON_BODY_LIMIT || "1mb" }));
app.use(securityHeaders);
app.use(apiLimiter);

app.get("/", async (req, res) => {
  res.send("Welcome to the home page");
});

app.get("/health", (req, res) => {
  const dbState = mongoose.connection.readyState;
  const dbStatus =
    dbState === 1 ? "connected" : dbState === 2 ? "connecting" : "disconnected";

  const status = dbStatus === "connected" ? 200 : 503;

  res.status(status).json({
    status: status === 200 ? "ok" : "degraded",
    uptime: process.uptime(),
    timestamp: new Date().toISOString(),
    dbStatus,
  });
});

app.use("/user", userRouter);

const __dirname = dirname(fileURLToPath(import.meta.url));
const uploadsDir = path.join(__dirname, "..", "uploads");

app.use("/uploads", express.static(uploadsDir));
app.use("/upload", uploadRouter);
app.use("/mail", mailRouter);
app.use("/message", protect, messageRouter);
app.use("/category", CategoryRouter);
app.use("/feedback", protect, feedbackRouter);
app.use("/request", protect, requestRouter);
app.use("/service", serviceRouter);

app.use(notFoundHandler);
app.use(errorHandler);

export default app;
