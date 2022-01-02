const express = require('express');

const app = express();

app.get('/', (req, res) => {
  res.send('Welcome to UMeGrow Happy NewYear');
});
app.listen(8080, () => {
  console.log('Listening on port 8080');
});
