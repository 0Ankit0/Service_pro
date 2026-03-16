import mongoose from "mongoose";

export default async function Connect() {
  try {
    await mongoose.connect(process.env.MONGODB_URI);
    const db = mongoose.connection;

    db.on("error", console.error.bind(console, "connection error:"));
    db.once("open", () => {
      console.log("Connected to MongoDB");
    });

    return db;
  } catch (error) {
    console.error("MongoDB connection failed", error);
    throw error;
  }
}
