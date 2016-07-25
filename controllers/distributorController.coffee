express = require 'express'
router = express.Router()

router.get '/', (req, res) ->
  res.render 'baseApp',
    module: 'distributor'
    title: '由你填写'

module.exports = router
