# WWL VM Modals

View module ([wwl-js-vm](https://github.com/wonderweblabs/wwl-js-vm)) implementation to maintain a stack of modals. The implementation is based on [backbone](http://backbonejs.org/) and [backbone.marionette](http://marionettejs.com/).

Each modal requires to get a view object (Backbone.View api compatible) to passed in for each modal. The model will render that view as content.




## Example

```coffeescript
context = new (require('wwl-js-app-context'))({ root: true })
vm      = new (require('wwl-js-vm-modals'))({ context: context })

vm.getView().render()
$('body').append(vm.getView().$el)

# Create a dummy content view
View = Backbone.View.extend({ template: '<div><h1>Test</h1></div>' })
view = new View()

# Create a modal
modal = vm.addModal({
  view:   view
  title:  'My first Modal'
  closeButton:      true
  backTopButton:    true
  backBottomButton: true
  destroyOnClose:   true
  cancelButton:     'Cancel'
  successButton:    'Save'
})

# Listen to your modal

modal.on 'view:render', ->
  # The modal view itself has been rendered
  null

modal.on 'view:action:click:success', ->
  # The modals success button ("Save") has been pressed
  null

```




## Installation

wwl-js-vm-modals requires sass, coffeescript, browserify, hamlify.

Make sure, that for sass and for browserify, the load paths are set up correctly.

```sass
// In your applications stylesheet:

// For cmi version:
@import 'wwl-js-vm-modals/base_cmi'

// For marionette-only version:
@import 'wwl-js-vm-modals/base_no_cmi'

```


```coffeescript
# In your js application:

# For cmi version:
VmClass = require('wwl-js-vm-modals')

# For marionette-only version:
VmClass = require('wwl-js-vm-modals/lib/vm')

```


### Cmi Version

**Important**: To run the cmi version, you need to install webcomponents and link at least:

```haml
%link{ rel: "import", href: "../paper-spinner/paper-spinner.html" }
%link{ rel: "import", href: "../cmi-button/cmi-button.html" }
%link{ rel: "import", href: "../cmi-button/cmi-button-link.html" }
%link{ rel: "import", href: "../cmi-dialog/cmi-dialog-scrollable.html" }
%link{ rel: "import", href: "../cmi-dialog/cmi-dialog.html" }
%link{ rel: "import", href: "../cmi-dialog/cmi-dialog-extended.html" }
```

Unfortunatly, it's not easy to automate this.




## General concept

The modals stack is maintained by a Backbone.Collection with Backbone.Model instances. Each model represents a modal you can see. A modal model requires at least the attribute ```view``` on initialization.

Every action happening on your modals view, you can listen to via the model.

The modal won't close or save automatically. You need to maintain this.

> The view you're passing in and the modal view itself don't have any knowledge about each other. E.g. if you need to persist form data from your inside view on ```'view:action:click:success'```, pass that information to your inner view by hand!




## Modal Model Attributes


| attribute | type | default | description |
|-----------|------|---------|-------------|
| view                | <sup>Backbone.View or same api</sup> | <sup>null</sup> | **required** - The view that will be rendered as content. |
| visible             | <sup>boolean</sup> | <sup>true</sup> | You can add modals to the collection without displaying them. Internally, we're using a Backbone.VirtualCollection to only display modals that got visible true. |
| closeButton         | <sup>boolean</sup> | <sup>true</sup> | If the x close button is visible. |
| backTopButton       | <sup>boolean</sup> | <sup>false</sup> | If the back button on top is visible. |
| backBottomButton    | <sup>boolean</sup> | <sup>false</sup> | If the back button on bottom is visible. |
| headline            | <sup>string</sup> | <sup>''</sup> | The headline of the modal. |
| cancelButton        | <sup>string</sup> | <sup>''</sup> | The text of the cancel button. If null, undefined or empty string, it will hide the button. |
| doneButton          | <sup>string</sup> | <sup>''</sup> | The text of the done button. If null, undefined or empty string, it will hide the button. |
| successButton       | <sup>string</sup> | <sup>''</sup> | The text of the success button (colored). If null, undefined or empty string, it will hide the button. |
| noCancelOnEscKey    | <sup>boolean</sup> | <sup>true</sup> | If true, you won't get a cancel event when pressing esc. |
| disableBackdropClickClose | <sup>boolean</sup> | <sup>false</sup> | Fire close event when clicking the backdrop. |
| viewId              | <sup>string</sup> | <sup>''</sup> | Set an id for the modal view (not your view you're passing in). |
| viewClass           | <sup>string</sup> | <sup>''</sup> | Set classes for the modal view (not your view you're passing in). |
| destroyOnCancel     | <sup>boolean</sup> | <sup>false</sup> | If to destroy the modal model (close modal), if the cancel event is fired. |
| destroyOnBackdrop   | <sup>boolean</sup> | <sup>false</sup> | If to destroy the modal model (close modal), if the backdrop has been clicked. |
| destroyOnClose      | <sup>boolean</sup> | <sup>false</sup> | If to destroy the modal model (close modal), if the close event has been fired. |
| | | | |
| *cmi modal only:*   | | | |
| entryAnimation      | <sup>string</sup> | <sup>'scale-up-animation'</sup> | See https://elements.polymer-project.org/elements/neon-animation?active=scale-up-animation | 
| exitAnimation       | <sup>string</sup> | <sup>'fade-in-animation'</sup> | See https://elements.polymer-project.org/elements/neon-animation?active=scale-up-animation |




## Modal Model Events

| event | description |
|-------|-------------|
| view:beforeRender           | Marionette event on the modal item view |
| view:render                 | Marionette event on the modal item view |
| view:beforeAttach           | Marionette event on the modal item view |
| view:attach                 | Marionette event on the modal item view |
| view:beforeShow             | Marionette event on the modal item view |
| view:show                   | Marionette event on the modal item view |
| view:domRefresh             | Marionette event on the modal item view |
| view:beforeDestroy          | Marionette event on the modal item view |
| view:destroy                | Marionette event on the modal item view |
| view:action:click:backdrop  | When clicked the backdrop. |
| view:action:click:cancel    | When clicked the cancel button. |
| view:action:click:done      | When clicked the done button. |
| view:action:click:success   | When clicked the success button. |
| view:action:click:back      | When clicked on of the back buttons. |
| view:action:click:close     | When clicked the close button (x). |




## With or without cmi webcomponents

By default the modal is build on base of [curo-material-interface](https://github.com/wonderweblabs/curo-material-interface).

So you'll get the webcomponents implementation if you call:

```coffeescript
require('wwl-js-vm-modals')
```

Or explicit:

```coffeescript
require('wwl-js-vm-modals/lib/vm_cmi')
```

If you want to have a marionette-only implementation, you would require the following:

```coffeescript
require('wwl-js-vm-modals/lib/vm')
```

