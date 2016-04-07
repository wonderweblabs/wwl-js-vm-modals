module.exports = class MainAbstractView extends require('backbone.marionette').CollectionView

  template: false

  initialize: ->
    @listenTo @collection, 'add',     @onCollectionChange
    @listenTo @collection, 'remove',  @onCollectionChange

  onRender: =>
    @onCollectionChange()

  onCollectionChange: =>
    @.$el.css 'display', if @collection.any() == true then 'block' else 'none'
    $('body').toggleClass 'wwl-js-vm-modals-active', @collection.any() == true
