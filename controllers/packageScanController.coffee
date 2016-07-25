express = require 'express'
router = express.Router()
config = require '../config'
fs = require 'fs'
path = require 'path'
apkUtils = require '../utils/apkUtils'
_ = require 'underscore'

packagesRoot = path.join __dirname, '..', config.packagesRoot

router.get '/', (req, res) ->
  {subfolder, filename} = req.query
  packagesPath = req.query?.path
  return res.send {err: '参数错误'} unless packagesPath
  packagesPath = path.join packagesRoot, packagesPath
  fs.exists packagesPath, (exists) ->
    return res.send {err: "'#{packagesPath}'不存在"} unless exists
    if not subfolder and not filename # 扫描包体目录
      fs.readdir packagesPath, (err, files) ->
        return res.send {err, files}
    else if subfolder and not filename # 扫描子目录
      subfolder = path.join packagesPath, subfolder
      fs.exists subfolder, (exists) ->
        return res.send {err: "'#{subfolder}'不存在"} unless exists
        fs.readdir subfolder, (err, files) ->
          files = _.filter files, (file) ->
            /\.apk$/.test file
          return res.send {err, files}
    else if subfolder and filename # 扫描包体文件(apk)
      subfolder = path.join packagesPath, subfolder
      filename = path.join subfolder, filename
      fs.exists filename, (exists) ->
        return res.send {err: "'#{filename}'不存在"} unless exists
        fs.stat filename, (err, stats) ->
          fileInfo = _.pick stats, 'ctime', 'mtime', 'size'
          apkUtils.parse filename, (err, apkInfo) ->
            return res.send {err: "'#{filename}'解析错误：#{err}"} if err
            _.extend fileInfo, apkInfo
            return res.send {err, file: fileInfo}
    else
      return res.send {err: '参数错误'}

module.exports = router
