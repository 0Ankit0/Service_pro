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
        return res.status(200).json({ category });
    } catch (error) {
        return res.status(500).json({ error: error.message });
    }
});
CategoryRouter.put("/update/:id", async (req, res) => {
    try {
        const category = await Category.findByIdAndUpdate(
            req.params.id,
            { $set: { "Services": req.body.Services } },
            { new: true } // to return updated document
        );
        return res.status(200).json({ message: "Category Updated Successfully" });
    } catch (error) {
        return res.status(500).json({ error: error.message });
    }
});
CategoryRouter.delete("/delete/:id", async (req, res) => {
    try {
        const category = await Category.findByIdAndDelete(req.params.id);
        return res.status(200).json({ message: "Category Deleted Successfully" });
    } catch (error) {
        return res.status(500).json({ error: error.message });
    }
});

export default CategoryRouter;
