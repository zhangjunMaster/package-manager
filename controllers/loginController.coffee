express = require 'express'
User = require '../models/user'
_ = require 'underscore'
config = require '../config'

router = express.Router()

router.get '/', (req, res) ->
  res.render 'login'

router.post '/', (req, res) ->
  {username, password} = req.body
  if username == 'root' and password == config.rootSecret
    req.session.user = {username, admin: true}
    res.redirect '../'
  else if username == 'vip' and password == config.vipSecret
    req.session.user = {username, vip: true}
    res.redirect '../'
  else
    User.findOne {username, password, roleid: config.salesRoleid}, (err, user) ->
      if user
        req.session.user = _.extend user, {username}
        res.redirect '../'
      else
        res.render 'login', {err: '用户名或密码错误：' + err}

module.exports = router
