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
        res.status(400).json({ message: error.message });
    }
});

serviceRouter.post('/add', protect, async (req, res) => {
    try {
        const service = await Service.create({ ...req.body, UserId: req.user.id });
        res.status(200).json({ message: "Service added successfully", data: service });
    } catch (error) {
        res.status(400).json({ message: error.message })
    }
});

serviceRouter.put('/update/:id', protect, async (req, res) => {
    try {
        const service = await Service.findByIdAndUpdate(req.params.id, req.body, { new: true });
        res.status(400).json({ message: "Service updated successfully", data: service });
    } catch (error) {
        res.status(200).json({ message: error.message })
    }
});

serviceRouter.delete('/delete/:id', protect, enforceRole('admin'), async (req, res) => {
    try {
        const service = await Service.findByIdAndUpdate(req.params.id, { Active: 0 });
        res.status(200).json({ message: "Service deleted successfully" });
    } catch (error) {
        res.status(400).json({ message: error.message })
    }
});

serviceRouter.get('/search/:name', async (req, res) => {
    try {
        // const services = await Service.find({ name: { $regex: req.params.name, $options: 'i' } }); // case insensitive search
        const services = await Service.find({ $text: { $search: req.params.name } }); //will search for the name in the text index
        res.status(200).json({ message: "Services fetched successfully", data: services });
    } catch (error) {
        res.status(400).json({ message: error.message });
    }
});

export default serviceRouter;