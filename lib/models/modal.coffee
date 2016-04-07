module.exports = class Modal extends require('backbone').Model

  defaults:
    visible:          true
    view:             null
    closeButton:      true
    backTopButton:    false
    backBottomButton: false
    headline:         ''
    title:            ''
    cancelButton:     ''
    doneButton:       ''
    successButton:    ''
    noCancelOnEscKey:           true
    disableBackdropClickClose:  false
    viewId:           ''
    viewClass:        ''

    destroyOnCancel:    false
    destroyOnBackdrop:  false
    destroyOnClose:     false

    # cmi only:
    entryAnimation:     'scale-up-animation'
    exitAnimation:      'fade-in-animation'

  initialize: (options = {}) =>
    @listenTo @, 'view:attach', @onViewAttach

  sync: =>
    # Prevent ajax

  getModalView: =>
    @_modalView or= null

  setModalView: (view) =>
    @_modalView = view

  resetModalView: =>
    @_modalView = null

  getJqDomContainer: =>
    @getModalView().$el

  getJqDomDialog: =>
    @getModalView().ui.cmiModal

  onBeforeRender: =>  @trigger 'view:beforeRender', @
  onRender: =>        @trigger 'view:render', @
  onBeforeAttach: =>  @trigger 'view:beforeAttach', @
  onAttach: =>        @trigger 'view:attach', @
  onBeforeShow: =>    @trigger 'view:beforeShow', @
  onShow: =>          @trigger 'view:show', @
  onDomRefresh: =>    @trigger 'view:domRefresh', @
  onBeforeDestroy: => @trigger 'view:beforeDestroy', @
  onDestroy: =>       @trigger 'view:destroy', @

  onBackdropClick: =>
    @destroy() if @get('destroyOnBackdrop') == true

    @trigger 'view:action:click:backdrop', @

  onModalDone: =>     @trigger 'view:action:click:done', @
  onModalSuccess: =>  @trigger 'view:action:click:success', @
  onModalBack: =>     @trigger 'view:action:click:back', @

  onModalCancel: =>
    @destroy() if @get('destroyOnCancel') == true

    @trigger 'view:action:click:cancel', @

  onModalClose: =>
    @destroy() if @get('destroyOnClose') == true

    @trigger 'view:action:click:close', @




