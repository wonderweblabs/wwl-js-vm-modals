module.exports = class FitBehavior extends require('backbone.marionette').Behavior

  ui: ->
    fitInto:          @getOption('fitInto') || window
    resizing:         @getOption('resizing')
    resizingTarget:   @getOption('resizingTarget')

  onDestroy: =>
    @_resetListeners()

  onBeforeRender: =>
    @_resetListeners()

  onRender: =>
    @_initializeListeners()
    @refit()
    console.log 'RENDER'

  onAttach: =>
    @refit()
    console.log 'ATTACH'

  onShow: =>
    @refit()
    console.log 'SHOW'

  onDomRefresh: =>
    @refit()
    console.log 'DOM REFRESH'

  onResize: =>
    @refit()

  onFitFit: ->
    @fit()

  onFitRefit: ->
    @refit()

  getFitInto: ->
    if _.isString(@getOption('fitInto')) then @ui.fitInto[0] else window

  getResizing: ->
    @ui.resizing[0]

  getResizingTarget: ->
    if _.isString(@getOption('resizingTarget')) then @ui.resizingTarget[0] else @getResizing()

  getFitWidth: ->
    return @getFitInto().innerWidth if @getFitInto() == window

    @getFitInto().getBoundingClientRect().width

  getFitHeight: ->
    return @getFitInto().innerHeight if @getFitInto() == window

    @getFitInto().getBoundingClientRect().height

  getFitLeft: ->
    return 0 if @getFitInto() == window

    @getFitInto().getBoundingClientRect().left

  getFitTop: ->
    return 0 if @getFitInto() == window

    @getFitInto().getBoundingClientRect().top

  fit: ->
    style = window.getComputedStyle(@getResizing())
    return if !style || style.display == 'none'

    @_loadFitInformation()
    @_constrain()
    @_center()

  refit: ->
    style = window.getComputedStyle(@getResizing())
    if !style || style.display == 'none'
      window.requestAnimationFrame =>
        style = window.getComputedStyle(@getResizing())
        return if !style || style.display == 'none'

        @_resetFit()
        @fit()
    else
      @_resetFit()
      @fit()


  # ----------------------------------------------------------
  # private - filter

  # @nodoc
  _resetListeners: ->
    $(window).off "resize.#{@cid}"

  # @nodoc
  _initializeListeners: ->
    $(window).on "resize.#{@cid}", @onResize

  # @nodoc
  _resetFit: ->
    if !@_fitInfo || !@_fitInfo.sizedBy.width
      @getResizingTarget().style.maxWidth = ''

    if !@_fitInfo || !@_fitInfo.sizedBy.height
      @getResizingTarget().style.maxHeight = ''

    @getResizing().style.top      = if @_fitInfo then @_fitInfo.inlineStyle.top else ''
    @getResizing().style.left     = if @_fitInfo then @_fitInfo.inlineStyle.left else ''
    @getResizing().style.position = @_fitInfo.positionedBy.css if @_fitInfo

    @_fitInfo = null

  # @nodoc
  _loadFitInformation: ->
    return unless @getResizing() && @getResizingTarget()

    target  = window.getComputedStyle(@getResizing())
    sizer   = window.getComputedStyle(@getResizingTarget())

    @_fitInfo =
      inlineStyle:
        top:  @getResizing().style.top || ''
        left: @getResizing().style.left || ''
      positionedBy:
        css: target.position
      sizedBy:
        height: sizer.maxHeight != 'none'
        width:  sizer.maxWidth != 'none'
      margin:
        top:    parseInt(target.marginTop, 10) || 0
        right:  parseInt(target.marginRight, 10) || 0
        bottom: parseInt(target.marginBottom, 10) || 0
        left:   parseInt(target.marginLeft, 10) || 0

    if target.top != 'auto'
      @_fitInfo.positionedBy.vertically = 'top'
    else if target.bottom != 'auto'
      @_fitInfo.positionedBy.vertically = 'bottom'
    else
      @_fitInfo.positionedBy.vertically = null

    if target.left != 'auto'
      @_fitInfo.positionedBy.horizontally = 'left'
    else if target.right != 'auto'
      @_fitInfo.positionedBy.horizontally = 'right'
    else
      @_fitInfo.positionedBy.horizontally = null

    @_fitInfo

  # @nodoc
  _constrain: ->
    # position at (0px, 0px) if not already positioned, so we can measure the natural size.
    @getResizing().style.top  = '0px' if !@_fitInfo.positionedBy.vertically
    @getResizing().style.left = '0px' if !@_fitInfo.positionedBy.horizontally

    # need position:fixed to properly size the element
    if !@_fitInfo.positionedBy.vertically || !@_fitInfo.positionedBy.horizontally
      @getResizing().style.position = 'fixed'

    # constrain the width and height if not already set
    rect = @getResizing().getBoundingClientRect()

    if !@_fitInfo.sizedBy.height
      @_sizeDimension(rect, @_fitInfo.positionedBy.vertically, 'top', 'bottom', 'Height')

    if !@_fitInfo.sizedBy.width
      @_sizeDimension(rect, @_fitInfo.positionedBy.horizontally, 'left', 'right', 'Width')

  # @nodoc
  _sizeDimension: (rect, positionedBy, start, end, extent) ->
    max           = if extent == 'Width' then @getFitWidth() else @getFitHeight()
    flip          = (positionedBy == end)
    offset        = if flip then max - rect[end] else rect[start]
    margin        = @_fitInfo.margin[if flip then start else end]
    offsetExtent  = 'offset' + extent
    sizingOffset  = @getResizing()[offsetExtent] - @getResizingTarget()[offsetExtent]

    @getResizingTarget().style['max' + extent] = (max - margin - offset - sizingOffset) + 'px'

  # @nodoc
  _center: ->
    # Already positioned.
    return if @_fitInfo.positionedBy.vertically && @_fitInfo.positionedBy.horizontally

    # Need position:fixed to center
    @getResizing().style.position = 'fixed'

    # Take into account the offset caused by parents that create stacking
    # contexts (e.g. with transform: translate3d). Translate to 0,0 and
    # measure the bounding rect.
    @getResizing().style.top = '0px'  if !@_fitInfo.positionedBy.vertically
    @getResizing().style.left = '0px' if !@_fitInfo.positionedBy.horizontally

    # It will take in consideration margins and transforms
    rect = @getResizing().getBoundingClientRect()

    if !@_fitInfo.positionedBy.vertically
      top = @getFitTop() - rect.top + (@getFitHeight() - rect.height) / 2
      @getResizing().style.top = top + 'px'

    if !@_fitInfo.positionedBy.horizontally
      left = @getFitLeft() - rect.left + (@getFitWidth() - rect.width) / 2
      @getResizing().style.left = left + 'px'


