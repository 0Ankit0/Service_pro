import { Service } from "../Modals/services.js";
import { Router } from "express";

const serviceRouter = Router();

serviceRouter.get('/', async (req, res) => {
    var services = await Service.find({}).lean().exec();
    res.json(services);
});

serviceRouter.post('/add', async (req, res) => {
    try {
        const service = await Service.create({ ...req.body, UserId: req.user.id });
        res.json(service);
    } catch (error) {
        res.json({ message: "Error occurred" })
    }
});

serviceRouter.put('/update/:id', async (req, res) => {
    try {
        const service = await Service.findByIdAndUpdate(req.params.id, req.body, { new: true });
        res.json(service);
    } catch (error) {
        res.json({ message: "Error occurred" })
    }
});

serviceRouter.delete('/delete/:id', async (req, res) => {
    try {
        const service = await Service.findByIdAndDelete(req.params.id);
        res.json(service);
    } catch (error) {
        res.json({ message: "Error occurred" })
    }
});

export default serviceRouter;