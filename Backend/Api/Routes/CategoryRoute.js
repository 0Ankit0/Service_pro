import { Router } from "express";

const CategoryRouter = Router();

CategoryRouter.get("/", async (req, res) => {
    try {
        const categories = await Category.find().lean().exec();
        return res.status(200).json({ categories });
    } catch (error) {
        return res.status(500).json({ error: error.message });
    }
});
export default CategoryRouter;
