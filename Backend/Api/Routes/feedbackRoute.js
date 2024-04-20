import { Feedback } from '../Modals/feedbacks.js'
import { Router } from 'express';

const feedbackRouter = Router();

feedbackRouter.get('/', async (req, res) => {
    var feedbacks = await Feedback.find({}).lean().exec();
    res.json(feedbacks);
});

feedbackRouter.post('/add', async (req, res) => {
    try {
        const feedback = await Feedback.create({ ...req.body, UserId: req.user.id });
        res.json(feedback);
    } catch (error) {
        res.json({ message: "Error occurred" })
    }
});

feedbackRouter.delete('/delete/:id', async (req, res) => {
    try {
        const feedback = await Feedback.findByIdAndDelete(req.params.id);
        res.json(feedback);
    } catch (error) {
        res.json({ message: "Error occurred" })
    }
});

feedbackRouter.put('/update/:id', async (req, res) => {
    try {
        const feedback = await Feedback.findByIdAndUpdate(req.params.id, req.body);
        res.json(feedback);
    } catch (error) {
        res.json({ message: "Error occurred" })
    }
});

export default feedbackRouter;