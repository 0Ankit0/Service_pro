import { Request } from "../Modals/requests.js";
import { Router } from "express";

const requestRouter = Router();

requestRouter.get('/', async (req, res) => {
    var requests = await Request.find({}).lean().exec();
    res.json(requests);
});

requestRouter.post('/add', async (req, res) => {
    try {
        const request = await Request.create({ ...req.body, UserId: req.user.id });
        res.json(request);
    } catch (error) {
        res.json({ message: "Error occurred" })
    }
});

requestRouter.put('/update/:id', async (req, res) => {
    try {
        const request = await Request.findByIdAndUpdate(req.params.id, req.body);
        res.json(request);
    } catch (error) {
        res.json({ message: "Error occurred" })
    }
});

requestRouter.delete('/delete/:id', async (req, res) => {
    try {
        const request = await Request.findByIdAndDelete(req.params.id);
        res.json(request);
    } catch (error) {
        res.json({ message: "Error occurred" })
    }
});

export default requestRouter;
