crypto = require 'crypto'

exports.cipher = (data, key) ->
  cipher = crypto.createCipher 'aes-128-cbc', key
