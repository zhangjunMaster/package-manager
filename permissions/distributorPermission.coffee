module.exports = (req, res, next) ->
  unless req.session.user?.vip
    next()
  else
    res.send 403, 'Sorry, access denied!'
