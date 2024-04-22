import { Router } from "express";
import { Category } from "../Modals/Category.js";

const CategoryRouter = Router();

CategoryRouter.get("/", async (req, res) => {
    try {
        const categories = await Category.find().lean().exec();
        return res.status(200).json({ categories });
    } catch (error) {
        return res.status(500).json({ error: error.message });
    }
});

CategoryRouter.post("/add", async (req, res) => {
    try {
        const category = await Category.create(req.body);
        return res.status(201).json({ category });
    } catch (error) {
        return res.status(500).json({ error: error.message });
    }
});
export default CategoryRouter;
