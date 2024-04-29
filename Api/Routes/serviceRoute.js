import { Service } from "../Modals/services.js";
import { Router } from "express";
import { protect } from "../Middleware/auth.js";

const serviceRouter = Router();

serviceRouter.get('/', async (req, res) => {
    var services = await Service.find({}).lean().exec();
    res.json(services);
});

serviceRouter.post('/add', protect, async (req, res) => {
    try {
        const service = await Service.create({ ...req.body, UserId: req.user.id });
        res.json({ message: "Service added successfully" });
    } catch (error) {
        res.json({ message: "Error occurred" })
    }
});

serviceRouter.put('/update/:id', protect, async (req, res) => {
    try {
        const service = await Service.findByIdAndUpdate(req.params.id, req.body, { new: true });
        res.json({ message: "Service updated successfully", data: service });
    } catch (error) {
        res.json({ message: "Error occurred" })
    }
});

serviceRouter.delete('/delete/:id', protect, async (req, res) => {
    try {
        const service = await Service.findByIdAndDelete(req.params.id);
        res.json({ message: "Service deleted successfully" });
    } catch (error) {
        res.json({ message: "Error occurred" })
    }
});

export default serviceRouter;