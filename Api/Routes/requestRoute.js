import { Request } from "../Modals/requests.js";
import { Router } from "express";

const requestRouter = Router();

requestRouter.get('/', async (req, res) => {
    try {

        var requests = await Request.find({}).lean().exec();
        res.status(200).json({ message: "Requests fetched successfully", data: requests });
    } catch (error) {
        res.status(400).json({ message: "Error occurred" });
    }
});

requestRouter.post('/add', async (req, res) => {
    try {
        const request = await Request.create({ ...req.body, UserId: req.user.id });
        res.status(200).json({ message: "Request added successfully", data: request });
    } catch (error) {
        res.status(400).json({ message: "Error occurred" })
    }
});

requestRouter.put('/update/:id', async (req, res) => {
    try {
        const request = await Request.findByIdAndUpdate(req.params.id, req.body);
        res.status(200).json({ message: "Request updated successfully", data: request });
    } catch (error) {
        res.status(400).json({ message: "Error occurred" })
    }
});

requestRouter.delete('/delete/:id', async (req, res) => {
    try {
        const request = await Request.findByIdAndDelete(req.params.id);
        res.status(200).json({ message: "Request deleted successfully" });
    } catch (error) {
        res.status(400).json({ message: "Error occurred" })
    }
});
requestRouter.post('/cancel/:id', async (req, res) => {
    try {
        const request = await Request.findByIdAndUpdate(req.params.id, { Status: "cancelled" });
        res.status(200).json({ message: "Request cancelled successfully", data: request });
    } catch (error) {
        res.status(400).json({ message: "Error occurred" })
    }
});

export default requestRouter;
