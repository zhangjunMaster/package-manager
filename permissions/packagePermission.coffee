module.exports = (req, res, next) ->
  if req.session.user?.admin or req.session.user?.vip
    next()
  else
    res.send 403, 'Sorry, access denied!'
