fs = require 'fs'

exports.copyFile = (source, target, cb) ->
  cbCalled = false

  rd = fs.createReadStream source
  rd.on "error", (err) ->
    done err
  wr = fs.createWriteStream target
  wr.on "error", (err) ->
    done(err)
  wr.on "close", (ex) ->
    done()
  rd.pipe wr

  done = (err) ->
    unless cbCalled
      cb err
      cbCalled = true
