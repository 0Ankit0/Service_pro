import { Feedback } from '../Modals/feedbacks.js'
import { Router } from 'express';

const feedbackRouter = Router();

feedbackRouter.get('/:userId', async (req, res) => {
    try {

        var feedbacks = await Feedback.find({ UserId: req.params.userId }).populate('ServiceId').populate({ path: 'UserId', select: 'Name' }).lean().exec();
        res.status(200).json({ message: "Feedbacks fetched successfully", data: feedbacks });
    } catch (error) {
        res.status(400).json({ message: error.message });

    }
});

feedbackRouter.post('/add', async (req, res) => {
    try {
        console.info(req.body)
        const feedback = await Feedback.create({ ...req.body, UserId: req.user.id });
        res.status(200).json({ message: "Feedback added successfully", data: feedback });
    } catch (error) {
        res.status(400).json({ message: error.message })
    }
});

feedbackRouter.delete('/delete/:id', async (req, res) => {
    try {
        const feedback = await Feedback.findByIdAndDelete(req.params.id);
        res.status(200).json({ message: "Feedback deleted successfully" });
    } catch (error) {
        res.status(400).json({ message: error.message })
    }
});

feedbackRouter.put('/update/:id', async (req, res) => {
    try {
        const feedback = await Feedback.findByIdAndUpdate(req.params.id, req.body, { new: true }).lean().exec();
        res.status(200).json({ message: "Feedback updated successfully", data: feedback });
    } catch (error) {
        res.status(400).json({ message: error.message })
    }
});

export default feedbackRouter;