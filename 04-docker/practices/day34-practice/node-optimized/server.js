const http = require('http');
const os = require('os');

const PORT = process.env.PORT || 3000;

const server = http.createServer((req, res) => {
    res.setHeader('Content-Type', 'application/json');

    if (req.url === '/health') {
        res.writeHead(200);
        res.end(JSON.stringify({
            status: 'healthy',
            timestamp: new Date().toISOString()
        }));
    } else {
        res.writeHead(200);
        res.end(JSON.stringify({
            service: 'node-optimized',
            node: process.version,
            stage: process.env.BUILD_STAGE || 'unknown',
            memory: Math.round(
                process.memoryUsage().heapUsed / 1024 / 1024
            ) + 'MB'
        }));
    }
});

server.listen(PORT, '0.0.0.0', () => {
    console.log(`Listening on :${PORT}`);
});
