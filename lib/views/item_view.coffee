module.exports = class ItemView extends require('./item_abstract_view')

  template: require('../tpl/item_view.hamlc')

  ui:
    modal:          '> .modal'
    closeButton:    '> .modal .wwl-button-close'
    backButton:     '> .modal .wwl-button-back'
    cancelButton:   '> .modal .wwl-button-cancel'
    doneButton:     '> .modal .wwl-button-done'
    successButton:  '> .modal .wwl-button-success'

  events:
    'click':                   'onBackdropClick'
    'click @ui.closeButton':   'onCmiModalClose'
    'click @ui.backButton':    'onCmiModalBack'
    'click @ui.cancelButton':  'onCmiModalCancel'
    'click @ui.doneButton':    'onCmiModalDone'
    'click @ui.successButton': 'onCmiModalSuccess'

  behaviors: ->
    FitBehavior:
      behaviorClass:  require('../behaviors/fit_behavior')
      fitInto:        @.el
      resizing:       '> .modal'
      resizingTarget: '> .modal .wwl-js-vm-modals-modal-content'

  onBackdropClick: (event) =>
    return if @ui.modal[0] == event.target
    return if $.contains(@ui.modal[0], event.target)

    event.preventDefault()
    event.stopPropagation()

    @model.onBackdropClick()

  onCmiModalCancel: =>  @model.onModalCancel()
  onCmiModalDone: =>    @model.onModalDone()
  onCmiModalSuccess: => @model.onModalSuccess()
  onCmiModalBack: =>    @model.onModalBack()
  onCmiModalClose: =>   @model.onModalClose()

  onChangeModel: ->
    null
