module.exports = class ItemAbstractView extends require('backbone.marionette').LayoutView

  className: 'wwl-js-vm-modals-modal'

  regions:
    content: '.wwl-js-vm-modals-modal-content'

  modelEvents:
    'change': 'onChangeModel'

  initialize: ->
    @model.setModalView(@)
    @model.trigger 'view:set', @model

  getContentRegion: ->
    @getRegion('content')

  onBeforeRender: =>  @model.onBeforeRender()
  onBeforeAttach: =>  @model.onBeforeAttach()
  onAttach: =>        @model.onAttach()
  onBeforeShow: =>    @model.onBeforeShow()
  onShow: =>          @model.onShow()
  onDomRefresh: =>    @model.onDomRefresh()
  onBeforeDestroy: => @model.onBeforeDestroy()
  onDestroy: =>       @model.onDestroy()

  onRender: =>
    @.$el.attr 'id', @model.get('viewId')
    @.$el.addClass @model.get('viewClass')

    @getContentRegion().show(@model.get('view'))

    @model.onRender()