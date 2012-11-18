console.log 'Hello world'

foobar = (cb) ->
  s = 3 + 4
  cb("fsdasdfa", s)

foobar (str, i) ->
  for n in [0..i]
    console.log "#{n}: #{str}"


