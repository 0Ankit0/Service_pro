import jwt from "jsonwebtoken";
import bcrypt from "bcrypt";
import { LoginLog } from "../Modals/LoginLog.js";

const JWT_EXPIRY = process.env.JWT_EXPIRES_IN || "24h";

export const createJWT = (user) => {
  const token = jwt.sign(
    { id: user.id, name: user.Name, Role: user.Role },
    process.env.JWTSecret,
    { expiresIn: JWT_EXPIRY }
  );
  return token;
};

export const hashPassword = (password) => {
  return bcrypt.hash(password, 10);
};

export const comparePassword = (hash, password) => {
  try {
    return bcrypt.compare(password, hash);
  } catch (error) {
    return false;
  }
};

export const protect = async (req, res, next) => {
  const bearer = req.headers.authorization;
  if (!bearer || !bearer.startsWith("Bearer ")) {
    return res.status(401).json({ message: "not authorized" });
  }

  const token = bearer.split(" ")[1];
  if (!token) {
    return res.status(401).json({ message: "Not a token" });
  }

  try {
    const user = jwt.verify(token, process.env.JWTSecret);

    const loginLog = await LoginLog.findOne({
      Token: token,
      logoutTime: { $ne: null },
    })
      .lean()
      .exec();

    if (loginLog) {
      return res.status(401).json({ message: "Token Already used" });
    }

    req.user = user;
    next();
  } catch (e) {
    return res.status(401).json({ message: "Invalid token" });
  }
};

export function enforceRole(role) {
  return function (req, res, next) {
    if (req.user.Role !== role) {
      return res.status(403).json({
        message: "Forbidden: You do not have permission to perform this action",
      });
    }
    next();
  };
}
