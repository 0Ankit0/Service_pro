import jwt from "jsonwebtoken";
import bcrypt from "bcrypt";

export const createJWT = (user) => {
    const token = jwt.sign({ id: user.id, name: user.Name }, process.env.JWTSecret);
    return token;
}
export const hashPassword = (password) => {
    return bcrypt.hash(password, 5);
}
export const comparePassword = (hash, password) => {
    try {

        return bcrypt.compare(password, hash);
    } catch (error) {
        return false;
    }
}
export const protect = (req, res, next) => {
    const bearer = req.headers.authorization
    if (!bearer) {
        res.status(401).json({ message: "not authorized" })
        return;
    }
    const [, token] = bearer.split(' ');
    if (!token) {
        res.status(401).json({ message: "Not a token" })
        return;
    }
    try {
        const user = jwt.verify(token, process.env.JWTSecret);
        req.user = user;
        next();
    } catch (e) {
        res.status(401).json({ message: "Invalid token" })
    }
}