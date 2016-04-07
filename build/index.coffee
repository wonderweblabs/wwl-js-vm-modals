require('webcomponentsjs/webcomponents')

global.$                          = require('jquery')
global.jquery                     = global.jQuery = global.$
global._                          = require 'underscore'
global.underscore                 = global._
global.Backbone                   = require 'backbone'
global.backbone                   = global.Backbone
global.Backbone.$                 = $

domready    = require 'domready'
wwlContext  = require 'wwl-js-app-context'

domready ->
  tester = new (require('wwl-js-vm')).Tester({

    domElementId: 'wwl-js-vm-tester-container'

    config:
      getDefaultVMConfig: ->
        context: new (wwlContext)({ root: true })

    vmConfig: _.extend({

      afterStart: (vm, moduleConfig) ->
        window.vm = vm
        model = window.vm.addModal({
          view: new (require('./test_view'))({
            viewModule: vm
          }),
          title: 'My Modal'
          destroyOnClose: true
        })

        model.on 'view:beforeRender', ->          console.log 'view:beforeRender'
        model.on 'view:render', ->                console.log 'view:render'
        model.on 'view:beforeAttach', ->          console.log 'view:beforeAttach'
        model.on 'view:attach', ->                console.log 'view:attach'
        model.on 'view:beforeShow', ->            console.log 'view:beforeShow'
        model.on 'view:show', ->                  console.log 'view:show'
        model.on 'view:domRefresh', ->            console.log 'view:domRefresh'
        model.on 'view:beforeDestroy', ->         console.log 'view:beforeDestroy'
        model.on 'view:destroy', ->               console.log 'view:destroy'
        model.on 'view:action:click:backdrop', -> console.log 'view:action:click:backdrop'
        model.on 'view:action:click:cancel', ->   console.log 'view:action:click:cancel'
        model.on 'view:action:click:done', ->     console.log 'view:action:click:done'
        model.on 'view:action:click:success', ->  console.log 'view:action:click:success'
        model.on 'view:action:click:back', ->     console.log 'view:action:click:back'
        model.on 'view:action:click:close', ->    console.log 'view:action:click:close'

    }, require('./vm_config'))

  }).run()
