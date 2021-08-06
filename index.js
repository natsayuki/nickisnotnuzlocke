const tmi = require('tmi.js');
const http = require('http');
const express = require('express');

const app = express();
const server = http.Server(app);

let lastMessage = '';

app.get('/', (req, res) => {
  res.send(lastMessage);
});

server.listen(1234);

const client = new tmi.Client({
  channels: ['The42ndTurtle']
})

client.connect();

client.on('message', (channel, tags, message, self) => {
  lastMessage = message.replace(/\d|\W/g, "").substring(0,9);
});

let port = process.env.PORT || 3000;

app.listen(port, () => {
  console.log(`server up on port ${port}`);
});
