import { Router } from "express";
import { Category } from "../Modals/Category.js";
import { protect } from "../Middleware/auth.js";

const CategoryRouter = Router();

CategoryRouter.get("/", async (req, res) => {
    try {
        const categories = await Category.find().lean().exec();
        return res.status(200).json({ message: "Categories fetched successfully", data: categories });
    } catch (error) {
        return res.status(400).json({ error: error.message });
    }
});

CategoryRouter.post("/add", protect, async (req, res) => {
    try {
        const category = await Category.create(req.body);
        return res.status(200).json({ message: "Category Added Successfully", data: category });
    } catch (error) {
        return res.status(400).json({ error: error.message });
    }
});
CategoryRouter.put("/update/:id", protect, async (req, res) => {
    try {
        const category = await Category.findByIdAndUpdate(
            req.params.id,
            { Services: req.body.Services },
            { new: true } // to return updated document
        );
        return res.status(200).json({ message: "Category Updated Successfully", data: category });
    } catch (error) {
        return res.status(400).json({ error: error.message });
    }
});
CategoryRouter.delete("/delete/:id", protect, async (req, res) => {
    try {
        const category = await Category.findByIdAndDelete(req.params.id);
        return res.status(200).json({ message: "Category Deleted Successfully" });
    } catch (error) {
        return res.status(500).json({ error: error.message });
    }
});

export default CategoryRouter;
