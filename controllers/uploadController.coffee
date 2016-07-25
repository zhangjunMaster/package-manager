express = require 'express'
router = express.Router()
config = require '../config'
fs = require 'fs'
fsUtils = require '../utils/fsUtils'
path = require 'path'
formidable = require 'formidable'

uploadDir = path.join __dirname, '/../tmp'
fs.mkdirSync uploadDir unless fs.existsSync uploadDir

packagesRoot = path.join __dirname, '..', config.packagesRoot

router.post '/', (req, res) ->
  form = new formidable.IncomingForm()
  form.encoding = 'utf-8'
  form.keepExtensions = true
  form.hash = 'sha1'
  form.uploadDir = uploadDir
  form.parse req, (err, fields, files) ->
    return res.status(500).send err if err
    {file} = files
    subfolderPath = path.join packagesRoot, fields.path, fields.subfolderName
    seedApkPath = path.join subfolderPath, file.name.replace /\.apk$/, '_seed.apk'
    fs.exists subfolderPath, (exists) ->
      fs.mkdirSync subfolderPath unless exists
      fsUtils.copyFile file.path, seedApkPath, (err) ->
        return res.status(500).send err if err
        res.send {file: seedApkPath}

module.exports = router
