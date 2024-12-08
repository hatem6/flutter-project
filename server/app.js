const express = require("express");
const app = express();
require("dotenv").config();
const port = process.env.PORT || 3001;
const cors = require("cors");
const mongoose = require("mongoose");
const mongodb_url = process.env.MONGODB_URL;
const UserModel = require("./models/User");
const ArticleModel = require("./models/Article");
app.use(express.json());
app.use(cors());

mongoose.connect(mongodb_url, {
  useNewUrlParser: true,
  useUnifiedTopology: true,
});
mongoose.connection.on("connected", () => {
  console.log("MongoDB connected");
});
mongoose.connection.on("error", (err) => {
  console.error("MongoDB connection error:", err);
});



const getNextUserId = async () => {
    const lastUser = await UserModel.findOne().sort({ id: -1 });
    return lastUser ? lastUser.id + 1 : 1;
  };
  app.post("/user/signup", async (req, res) => {
    try {
      // Check if the email already exists
      const existingUser = await UserModel.findOne({ email: req.body.email });
      if (existingUser) {
        return res.status(400).json({ error: "Email already exists" });
      }
  
      // Generate the next ID
      const nextId = await getNextUserId();
  
      // Create a new user
      const user = new UserModel({
        id: nextId,
        fullname: req.body.fullname,
        email: req.body.email,
        password: req.body.password,
      });
  
      await user.save();
      res.status(201).json({ success: true, user });
      console.log("User saved successfully");
    } catch (err) {
      console.error("Error creating user:", err);
      res.status(500).json({ error: "Failed to create user" });
    }
  });

  app.post("/user/signin", async (req, res) => {
    try {
      // Check if the email exists
      const user = await UserModel.findOne({ email: req.body.email });
      if (!user) {
        return res.status(404).json({ error: "User not found" });
      }
  
      // Check if the provided password matches the stored password (plain text comparison)
      if (req.body.password !== user.password) {
        return res.status(400).json({ error: "Invalid credentials" });
      }
  
      // If credentials are valid, return success message (no token generation)
      res.status(200).json({ success: true, message: "Signin successful",user });
    } catch (err) {
      console.error("Error signing in:", err);
      res.status(500).json({ error: "Failed to sign in" });
    }
  });

// Helper function to get the next article ID
const getNextArticleId = async () => {
    const lastArticle = await ArticleModel.findOne().sort({ id: -1 });
    return lastArticle ? lastArticle.id + 1 : 1;
  };
  
  // Route to create an article
  app.post("/article/create", async (req, res) => {
    try {
      const { title, content, userId } = req.body;
  
      // Validate required fields
      if (!title || !content || !userId) {
        return res.status(400).json({ error: "All fields (title, content, userId) are required" });
      }
  
      // Check if the user exists
      const user = await UserModel.findOne({ id: userId });
      if (!user) {
        return res.status(404).json({ error: "User not found" });
      }
  
      // Generate the next article ID
      const nextId = await getNextArticleId();
  
      // Create a new article
      const article = new ArticleModel({
        id: nextId,
        title,
        content,
        userId,
      });
  
      await article.save();
      res.status(201).json({ success: true, article });
      console.log("Article created successfully");
    } catch (err) {
      console.error("Error creating article:", err);
      res.status(500).json({ error: "Failed to create article" });
    }
  });

  app.get("/articles/user/:userId", async (req, res) => {
    try {
      const { userId } = req.params;
  
      // Fetch all articles for the given userId
      const articles = await ArticleModel.find({ userId: parseInt(userId) });
  
      if (articles.length === 0) {
        return res.status(404).json({ error: "No articles found for this user" });
      }
  
      res.status(200).json({ success: true, articles });
    } catch (err) {
      console.error("Error fetching articles by userId:", err);
      res.status(500).json({ error: "Failed to fetch articles" });
    }
  });
  app.get("/article/:id", async (req, res) => {
    try {
      const { id } = req.params;
  
      // Fetch the article by id
      const article = await ArticleModel.findOne({ id: parseInt(id) });
  
      if (!article) {
        return res.status(404).json({ error: "Article not found" });
      }
  
      res.status(200).json({ success: true, article });
    } catch (err) {
      console.error("Error fetching article by id:", err);
      res.status(500).json({ error: "Failed to fetch article" });
    }
  });

  // Update article by ID
app.put("/article/:id", async (req, res) => {
  try {
    const { id } = req.params;
    const { title, content} = req.body;

    if (!title || !content ) {
      return res.status(400).json({ error: "All fields are required" });
    }

    const updatedArticle = await ArticleModel.findOneAndUpdate(
      { id: parseInt(id) },
      { title, content },
      { new: true }
    );

    if (!updatedArticle) {
      return res.status(404).json({ error: "Article not found" });
    }

    res.status(200).json({ success: true, article: updatedArticle });
  } catch (err) {
    console.error("Error updating article by id:", err);
    res.status(500).json({ error: "Failed to update article" });
  }
});

app.delete("/article/:id", async (req, res) => {
  try {
    const { id } = req.params;

    const deletedArticle = await ArticleModel.findOneAndDelete({ id: parseInt(id) });

    if (!deletedArticle) {
      return res.status(404).json({ error: "Article not found" });
    }

    res.status(200).json({ success: true, message: "Article deleted successfully" });
  } catch (err) {
    console.error("Error deleting article by id:", err);
    res.status(500).json({ error: "Failed to delete article" });
  }
});
  


app.listen(port, () => {
  console.log("Server is running perfectly!");
});