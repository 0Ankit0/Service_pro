import { Feedback } from '../Modals/feedbacks.js'
import { Router } from 'express';

const feedbackRouter = Router();

feedbackRouter.get('/', async (req, res) => {
    try {

        var feedbacks = await Feedback.find({}).lean().exec();
        res.status(200).json({ message: "Feedbacks fetched successfully", data: feedbacks });
    } catch (error) {
        res.status(400).json({ message: "Error occurred" });

    }
});

feedbackRouter.post('/add', async (req, res) => {
    try {
        const feedback = await Feedback.create({ ...req.body, UserId: req.user.id });
        res.status(200).json({ message: "Feedback added successfully" });
    } catch (error) {
        res.status(400).json({ message: "Error occurred" })
    }
});

feedbackRouter.delete('/delete/:id', async (req, res) => {
    try {
        const feedback = await Feedback.findByIdAndDelete(req.params.id);
        res.status(200).json({ message: "Feedback deleted successfully" });
    } catch (error) {
        res.status(400).json({ message: "Error occurred" })
    }
});

feedbackRouter.put('/update/:id', async (req, res) => {
    try {
        const feedback = await Feedback.findByIdAndUpdate(req.params.id, req.body);
        res.status(200).json({ message: "Feedback updated successfully" });
    } catch (error) {
        res.status(400).json({ message: "Error occurred" })
    }
});

export default feedbackRouter;