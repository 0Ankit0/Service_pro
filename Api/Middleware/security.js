import rateLimit from "express-rate-limit";

const DEFAULT_ALLOWED_ORIGINS = ["*"];

const getAllowedOrigins = () => {
  const origins = process.env.CORS_ORIGINS
    ? process.env.CORS_ORIGINS.split(",").map((origin) => origin.trim())
    : DEFAULT_ALLOWED_ORIGINS;
  return origins.filter(Boolean);
};

export const corsOptions = {
  origin(origin, callback) {
    const allowedOrigins = getAllowedOrigins();
    if (!origin || allowedOrigins.includes("*") || allowedOrigins.includes(origin)) {
      return callback(null, true);
    }
    return callback(new Error("Origin not allowed by CORS"));
  },
  credentials: true,
};

export const apiLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: Number(process.env.RATE_LIMIT_MAX || 300),
  standardHeaders: true,
  legacyHeaders: false,
  message: {
    message: "Too many requests, please try again later.",
  },
});

export const securityHeaders = (req, res, next) => {
  res.setHeader("X-Content-Type-Options", "nosniff");
  res.setHeader("X-Frame-Options", "DENY");
  res.setHeader("Referrer-Policy", "strict-origin-when-cross-origin");
  res.setHeader("X-XSS-Protection", "0");
  res.setHeader("Permissions-Policy", "camera=(), microphone=(), geolocation=()");
  next();
};

export const notFoundHandler = (req, res) => {
  res.status(404).json({ message: "Route not found" });
};

export const errorHandler = (err, req, res, next) => {
  console.error(err);
  const statusCode = err.status || 500;
  const message = statusCode === 500 ? "Internal server error" : err.message;

  res.status(statusCode).json({ message });
};
