module.exports = class ModalsCollection extends require('backbone').Collection

  model: require('../models/modal')

  sync: =>
    # Prevent ajax