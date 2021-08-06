const channels = ['the42ndturtle', 'nickisnotgreen'];

const tmi = require('tmi.js');
const http = require('http');
const express = require('express');

const app = express();
const server = http.Server(app);

const messages = {}
let lastMessage = 'test';

app.get('/', (req, res) => {
  res.send('dummy thicc');
});

channels.forEach(channel => {
  console.log(channel);
  app.get(`/${channel.toLowerCase()}`, (req, res) => {
    res.send(messages[channel]);
    console.log(messages[channel]);
  });
});

server.listen(1234);

const client = new tmi.Client({
  channels: channels
});

client.connect();

client.on('message', (channel, tags, message, self) => {
  // console.log(channel.substring(1), message);
  messages[channel.substring(1)] = message.replace(/\d|\W/g, "").substring(0,9);
});

let port = process.env.PORT || 3000;

app.listen(port, () => {
  console.log(`server up on port ${port}`);
});
