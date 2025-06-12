const express = require('express');
const os = require('os');
const app = express();

app.get('/', (req, res) => {
  res.send(`Hello from container: ${os.hostname()} with IP: ${req.socket.localAddress}\n`);
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Listening on port ${PORT}`));
