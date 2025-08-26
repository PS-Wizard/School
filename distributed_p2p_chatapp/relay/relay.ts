import http from 'http';
import Gun from 'gun';
import 'gun/axe.js';

const server = http.createServer((req, res) => {
    res.writeHead(200);
    res.end('ok');
});

const gun = Gun({
    web: server,
    file: 'data', // optional, stores data on disk
});

server.listen(8080, () => {
    console.log('GUN relay server running on http://localhost:8080');
});
