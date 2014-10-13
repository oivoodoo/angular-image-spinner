# Angular Image Spinner

Using [spin.js](http://fgnass.github.com/spin.js) showing the spinner while
image is preloading on the background.

```html
  <img src='http://www.example.com/image.jpg' image-spinner width=100 height=200 />
```

Also it's possible to pass spin.js settings using ```image-spinner-settings```
attribute for ```img``` element.

**Note: The directive will not be applied if you missed one of the parameters `width`, `height`.**


## Installation

```
bower install angular-image-spinner --save
```

**Then**, add `imageSpinner` module to your app:

```javascript
angular
  .module('example', [
    /**
    // your other used modules
    **/
    'imageSpinner'
  ])
```
