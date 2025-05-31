const express = require('express');
const app = express();
const port = 80;

app.get('/', (req, res) => {
  res.send('Hello from my Node.js app running on a custom AMI! This project is powered by Chinmaya, passionate about DevOps and cloud technologies.');
});
// veera

app.listen(port, () => {
  console.log(`App listening at http://localhost:${port}`);
});
