const express = require('express');
const https = require('https');
const fs = require('fs');
const app = express();

app.use(express.static(__dirname + '/public'));

app.get('/', (req, res) => {
  res.sendFile(__dirname + '/public/index.html');
});

// Charger certificat auto-signé
const options = {
  key: fs.readFileSync('key.pem'),
  cert: fs.readFileSync('cert.pem')
};

https.createServer(options, app).listen(3001, () => {
  console.log('Site dispo sur https://localhost:3001');
});
