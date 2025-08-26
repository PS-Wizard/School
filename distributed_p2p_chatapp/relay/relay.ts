import https from 'https';
import fs from 'fs';
import Gun from 'gun';
import 'gun/axe.js';

// self-signed cert + key
const server = https.createServer(
  {
    key: fs.readFileSync('key.pem'),
    cert: fs.readFileSync('cert.pem'),
  },
  (req, res) => {
    res.writeHead(200);
    res.end('Relay running');
  }
);

Gun({ web: server });

server.listen(8080, '0.0.0.0', () => {
  console.log('GUN relay running at https://0.0.0.0:8080/gun');
});
