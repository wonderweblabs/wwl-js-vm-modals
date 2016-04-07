module.exports = class ItemCmiView extends require('./item_abstract_view')

  template: require('../tpl/item_cmi_view.hamlc')

  ui:
    cmiModal: 'cmi-dialog-extended'

  events:
    'click':                                    'onBackdropClick'
    'cmi-dialog-extended-cancel @ui.cmiModal':  'onCmiModalCancel'
    'cmi-dialog-extended-done @ui.cmiModal':    'onCmiModalDone'
    'cmi-dialog-extended-success @ui.cmiModal': 'onCmiModalSuccess'
    'cmi-dialog-extended-back @ui.cmiModal':    'onCmiModalBack'
    'cmi-dialog-extended-close @ui.cmiModal':   'onCmiModalClose'

  onRender: =>
    @_setModalAttributes()

    super()

  onShow: =>
    @_setModalAttributes()

    super()

  onAttach: =>
    @_setModalAttributes()

    super()

  onBackdropClick: (event) =>
    return if @ui.cmiModal[0] == event.target
    return if $.contains(@ui.cmiModal[0], event.target)

    event.preventDefault()
    event.stopPropagation()

    @model.onBackdropClick()

  onCmiModalCancel: =>  @model.onModalCancel()
  onCmiModalDone: =>    @model.onModalDone()
  onCmiModalSuccess: => @model.onModalSuccess()
  onCmiModalBack: =>    @model.onModalBack()
  onCmiModalClose: =>   @model.onModalClose()

  onChangeModel: =>
    @_setModalAttributes()

    @.$el.attr 'id', @model.get('viewId')
    @.$el.removeClass()
    @.$el.addClass("#{@className} #{@model.get('viewClass')}")


  # ----------------------------------------------------------
  # private - filter

  # @nodoc
  _setModalAttributes: ->
    return unless @ui.cmiModal[0]

    m = @ui.cmiModal[0]

    headline = @model.get('title')
    headline = @model.get('headline') if !_.isString(headline) || headline == ''

    m.fitInto           = @.el
    m.headline          = headline
    m.closeBtn          = @model.get('closeButton')
    m.cancelBtn         = @model.get('cancelButton')
    m.doneBtn           = @model.get('doneButton')
    m.successBtn        = @model.get('successButton')
    m.backBtnTop        = @model.get('backTopButton')
    m.backBtnBottom     = @model.get('backBottomButton')
    m.noCancelOnEscKey  = @model.get('noCancelOnEscKey')
    m.entryAnimation    = @model.get('entryAnimation')
    m.exitAnimation     = @model.get('exitAnimation')
    m.noCancelOnOutsideClick = true


