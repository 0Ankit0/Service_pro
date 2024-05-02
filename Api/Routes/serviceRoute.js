import { Service } from "../Modals/services.js";
import { Router } from "express";
import { protect } from "../Middleware/auth.js";
import { enforceRole } from "../Middleware/auth.js";

const serviceRouter = Router();

serviceRouter.get('/', async (req, res) => {
    try {

        var services = await Service.find({}).lean().exec();
        res.status(200).json({ message: "Services fetched successfully", data: services });
    } catch (error) {
        res.status(400).json({ message: "Error occurred" });
    }
});

serviceRouter.post('/add', protect, async (req, res) => {
    try {
        const service = await Service.create({ ...req.body, UserId: req.user.id });
        res.status(200).json({ message: "Service added successfully", data: service });
    } catch (error) {
        res.status(400).json({ message: "Error occurred" })
    }
});

serviceRouter.put('/update/:id', protect, async (req, res) => {
    try {
        const service = await Service.findByIdAndUpdate(req.params.id, req.body, { new: true });
        res.status(400).json({ message: "Service updated successfully", data: service });
    } catch (error) {
        res.status(200).json({ message: "Error occurred" })
    }
});

serviceRouter.delete('/delete/:id', protect, enforceRole('Admin'), async (req, res) => {
    try {
        const service = await Service.findByIdAndDelete(req.params.id);
        res.status(200).json({ message: "Service deleted successfully" });
    } catch (error) {
        res.status(400).json({ message: "Error occurred" })
    }
});

export default serviceRouter;