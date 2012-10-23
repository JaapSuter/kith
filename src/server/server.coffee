express = require('express')

server = express()

server.use(express.logger())

server.get('/', (req, rsp) ->
  rsp.send 'Hello All Apple!'
)

port = process.env.PORT || 5000

server.listen(port, ->
  console.log("Listening on " + port)
);