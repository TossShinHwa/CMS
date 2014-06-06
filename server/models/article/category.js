var mongoose = require('mongoose');

var Schema = mongoose.Schema;

var CategorySchema = new Schema({
  name: String,
  url: {
    type: String,
    unique: true
  },
  description: String,
  isDefault: Boolean,
  subCategory:{
    name: String,
    url: {
      type: String,
      unique: true
    },
    description: String
  }
});

mongoose.model("Category", CategorySchema);