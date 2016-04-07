module.exports = class VmAbstract extends require('wwl-js-vm').VM

  addModal: (attributes) ->
    @getCollection().add(attributes)

  getModalsCollection: ->
    @getCollection()

  getCollection: ->
    @_collection or= new (require('./collections/modals_collection'))()

  getFilteredCollection: ->
    @_filteredCollection or= new (require('backbone-virtual-collection'))(
      @getCollection(), { filter: (f) => f.get('visible') == true }
    )

  getMainViewOptions: ->
    _.extend(super(), {
      collection: @getFilteredCollection()
    })