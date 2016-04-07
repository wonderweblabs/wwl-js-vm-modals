module.exports = class TestView extends require('backbone.marionette').LayoutView

  template: '#test-view-template'

  className: 'test-view'

  ui:
    button: 'cmi-button'

  events:
    'click @ui.button': 'onButtonClick'

  onButtonClick: (event) ->
    event.preventDefault()

    @getOption('viewModule').getCollection().add({
      view: new (require('./test_view'))({ viewModule: @getOption('viewModule') })
      title:          'Some other modal'
      successButton:  'Save it'
      cancelButton:   'No no no'
    })