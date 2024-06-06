const express = require('express');
const http = require('http');
const https = require('https');
const cors = require('cors');

const app = express();
const port = 3000;

app.use(cors());

app.get('/proxy', (req, res) => {
  const url = req.query.url;
  if (!url) {
    return res.status(400).send('URL is required');
  }

  const client = url.startsWith('https') ? https : http;
  client.get(url, (proxyRes) => {
    proxyRes.pipe(res, { end: true });
  }).on('error', (err) => {
    res.status(500).send(err.message);
  });
});

app.listen(port, () => {
  console.log(`Proxy server listening at http://localhost:${port}`);
});
