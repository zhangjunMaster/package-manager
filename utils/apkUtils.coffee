config = require '../config'
execFile = require('child_process').execFile
_ = require 'underscore'

module.exports =
  parse: (filename, cb) ->
    apkInfo = {}
    parsePackageInfo filename, (err, packageInfo) ->
      return cb err if err
      _.extend apkInfo, packageInfo
      parseProjectInfo filename, (err, projectInfo) ->
        return cb err if err
        _.extend apkInfo, projectInfo
        parseSubProjectInfo filename, (err, subProjectInfo) ->
          return cb err if err
          apkInfo.projectid += '_' + subProjectInfo.subProjectid if subProjectInfo?.subProjectid
          cb null, apkInfo
