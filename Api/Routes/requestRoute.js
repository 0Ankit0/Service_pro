import { Request } from "../Modals/requests.js";
import { Router } from "express";
import { User } from "../Modals/users.js";

const requestRouter = Router();

requestRouter.get('/', async (req, res) => {
    try {
        var requests = await Request.find({
            $or: [
                { userid: req.body.id },
                { providerid: req.body.id }
            ]
        }).lean().exec();
        res.status(200).json({ message: "Requests fetched successfully", data: requests });
    } catch (error) {
        res.status(400).json({ message: error.message });
    }
});

requestRouter.post('/add', async (req, res) => {
    try {
        const request = await Request.create({ ...req.body, UserId: req.user.id });
        res.status(200).json({ message: "Request added successfully", data: request });
    } catch (error) {
        res.status(400).json({ message: error.message })
    }
});

requestRouter.put('/update/:id', async (req, res) => {
    try {
        const request = await Request.findByIdAndUpdate(req.params.id, req.body);
        res.status(200).json({ message: "Request updated successfully", data: request });
    } catch (error) {
        res.status(400).json({ message: error.message })
    }
});

requestRouter.delete('/delete/:id', async (req, res) => {
    try {
        const request = await Request.findByIdAndDelete(req.params.id);
        res.status(200).json({ message: "Request deleted successfully" });
    } catch (error) {
        res.status(400).json({ message: error.message })
    }
});
requestRouter.post('/cancel/:id', async (req, res) => {
    try {
        const request = await Request.findByIdAndUpdate(req.params.id, { Status: "cancelled" });
        res.status(200).json({ message: "Request cancelled successfully", data: request });
    } catch (error) {
        res.status(400).json({ message: error.message })
    }
});

requestRouter.post('/accept/:id', async (req, res) => {
    try {
        const request = await Request.findByIdAndUpdate(req.params.id, { Status: "accepted" }, { new: true });
        if (request.Status === "accepted") {
            User.findByIdAndUpdate(request._id, { $inc: { "ServiceAnalytics.TotalServices": 1 } });
        }
        res.status(200).json({ message: "Request accepted successfully", data: request });

    } catch (error) {
        res.status(400).json({ message: error.message })
    }
});

requestRouter.post('/reject/:id', async (req, res) => {
    try {
        const request = await Request.findByIdAndUpdate(req.params.id, { Status: "rejected" });
        res.status(200).json({ message: "Request rejected successfully", data: request });
    } catch (error) {
        res.status(400).json({ message: error.message })
    }
});

requestRouter.post('/complete/:id', async (req, res) => {
    try {
        const request = await Request.findByIdAndUpdate(req.params.id, { Status: "completed" }, { new: true });
        if (request.Status === "completed") {
            User.findByIdAndUpdate(request._id, { $inc: { "ServiceAnalytics.CompletedServices": 1 } });
        }
        res.status(200).json({ message: "Request completed successfully", data: request });
    } catch (error) {
        res.status(400).json({ message: error.message })
    }
});

export default requestRouter;
