#!/usr/bin/env node

const { createServer, IncomingMessage, ServerResponse } = require("unit-http");
require("http").ServerResponse = ServerResponse;
require("http").IncomingMessage = IncomingMessage;
const express = require("express");
const request = require("request");
const prettyHtml = require('json-pretty-html').default;

const app = express();

app.use('/admin/static', express.static('public'))

app.get("/admin/", (req, res) => res.send("From NodeJS Express: Hello, World!"));

app.get("/admin/config", (req, res) => {
  request(
    "http://127.0.0.1:9090/config",
    { json: true },
    (err, restResponse, body) => {
      if (err) {
        return console.log(err);
      }
      const jsonHtml = prettyHtml(body, body);
      res.send(`<html><head><link rel="stylesheet" href="/admin/static/style.css"></head>${jsonHtml}</html>`);
    }
  );
});

createServer(app).listen();
