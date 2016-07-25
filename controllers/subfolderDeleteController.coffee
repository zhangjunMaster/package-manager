express = require 'express'
router = express.Router()
config = require '../config'
fs = require('fs-extra')
path = require 'path'

packagesRoot = path.join __dirname, '..', config.packagesRoot

router.get '/', (req, res) ->
  {subfolder} = req.query
  packagesPath = req.query?.path
  return res.send {err: '参数错误'} unless packagesPath and subfolder
  subfolderPath = path.join packagesRoot, packagesPath, subfolder
  fs.remove subfolderPath, (err) ->
    return res.status(500).send {err} if err
    res.send {subfolderPath: subfolderPath}

module.exports = router
