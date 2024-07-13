const express = require('express');
const http = require('http');
const https = require('https');
const cors = require('cors');

const app = express();
const port = 3000;

app.use(cors());
app.use(express.json());

app.all('/proxy', (req, res) => {
  const url = req.query.url;
  if (!url) {
    console.log('URL is required');
    return res.status(400).send('URL is required');
  }

  const client = url.startsWith('https') ? https : http;
  const options = {
    method: req.method,
    headers: req.headers,
  };

  console.log(`Forwarding ${req.method} request to: ${url}`);
  console.log('Headers:', req.headers);
  console.log('Body:', req.body);

  const proxyReq = client.request(url, options, (proxyRes) => {
    res.writeHead(proxyRes.statusCode, proxyRes.headers);
    proxyRes.pipe(res, { end: true });
  });

  proxyReq.on('error', (err) => {
    console.log('Proxy request error:', err.message);
    res.status(500).send(err.message);
  });

  if (req.method === 'POST' || req.method === 'PUT') {
    req.pipe(proxyReq);
  } else {
    proxyReq.end();
  }
});

app.listen(port, () => {
  console.log(`Proxy server listening at http://localhost:${port}`);
});
