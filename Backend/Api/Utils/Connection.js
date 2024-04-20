import mongoose from 'mongoose';
export default function Connect() {
    mongoose.connect(process.env.MONGODB_URI);
    //at the end of the url, add the name of the database you created in MongoDB Atlas if you want to use that database
    const db = mongoose.connection;
    db.on('error', console.error.bind(console, 'connection error:'));
    db.once('open', () => {
        console.log('Connected to MongoDB');
    });
    return db;
}

