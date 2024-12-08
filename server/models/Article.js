const mongoose = require("mongoose");
const ArticleSchema = new mongoose.Schema({
  id: {
    type: Number,
    required: true,
  },
  title: {
    type: String,
    required: true,
  },
  content: {
    type: String,
    required: true,
  },
  userId: {
    type: Number,
    required: true,
  },
});

const ArticleModel = mongoose.model("articles", ArticleSchema);
module.exports = ArticleModel;