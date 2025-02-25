import http from 'http';
import figlet from 'figlet';

const port = 4032;

const server = http.createServer((req, res) => {
  const body = figlet.textSync("Hey!");
  res.writeHead(200, { 'Content-Type': 'text/plain' });
  res.end(body);
});

server.listen(port, () => {
  console.log(`Listening on http://localhost:${port} ...`);
});