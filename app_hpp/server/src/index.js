const express = require('express');
const app = express();
const port = 3000;

const tokenController = require('./src/tokenController');
const dataController = require('./src/dataController');

app.use(express.json());

app.post('/api/login', tokenController.getToken);
app.get('/api/data', dataController.getData);

app.listen(port, () => {
  console.log(`Server running on http://localhost:${port}`);
});
