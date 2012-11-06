@echo off
cls

set NODE_ENV=development
set PATH=node_modules/.bin;C:\Users\Jaap\AppData\Roaming\npm\;C:\Program Files\nodejs\;

supervisor --verbose --watch src/server src/server/app.js

