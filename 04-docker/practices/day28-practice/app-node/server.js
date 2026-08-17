const http = require('http');
const os = require('os');

const PORT = process.env.PORT || 3000;
const APP_ENV = process.env.APP_ENV || 'production';
const APP_VERSION = process.env.APP_VERSION || '1.0.0';

const server = http.createServer((req, res) => {
    res.setHeader('Content-Type', 'application/json');

    if (req.url === '/health') {
        res.writeHead(200);
        res.end(JSON.stringify({
            status: 'healthy',
            version: APP_VERSION,
            environment: APP_ENV,
            timestamp: new Date().toISOString()
        }, null, 2));
    } else if (req.url === '/') {
        res.writeHead(200);
        res.end(JSON.stringify({
            message: 'Node.js App Running in Docker!',
            author: 'Asim Raza',
            hostname: os.hostname(),
            nodeVersion: process.version
        }, null, 2));
    } else {
        res.writeHead(404);
        res.end(JSON.stringify({ error: 'Not found' }));
    }
});

server.listen(PORT, '0.0.0.0', () => {
    console.log(`Server running on port ${PORT}`);
    console.log(`Environment: ${APP_ENV}`);
});
