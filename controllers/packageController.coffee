express = require 'express'
router = express.Router()

router.get '/', (req, res) ->
  res.render 'baseApp',
    module: 'package'
    title: '由你来写'

module.exports = router
