express = require('express')

server = express()

server.use(express.logger())

server.get('/', (req, rsp) ->
  rsp.send 'Hello All Banana!'
)

port = process.env.PORT || 5000

server.listen(port, ->
  console.log("Listening on " + port)
);