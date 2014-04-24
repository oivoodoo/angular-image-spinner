angular.module('imageSpinner')

# Default settings for spin.js library.
.constant 'imageSpinnerDefaultSettings',
    lines     : 9
    length    : 10
    width     : 2
    radius    : 3
    corners   : 1
    rotate    : 0
    direction : 1
    color     : '#000'
    speed     : 1
    trail     : 10
    shadow    : false
    hwaccel   : false
    className : 'spinner'
    zIndex    : 2000000000
    top       : '50%'
    left      : '50%'

.directive 'imageSpinner', [
    '$window', 'imageSpinnerDefaultSettings'
    ($window, DefaultSettings) ->
        ImageLoader = $window.Image

        class SpinnerBuilder
            constructor: (@el, @settings) ->
                settings ?= {}
                settings = angular.extend(settings, DefaultSettings)
                @spinner = new Spinner(settings)

                @container = @el.parent()
                @setContainerSize()

            setContainerSize: ->
                width  = @el.attr('width')  || '100'
                height = @el.attr('height') || '100'

                width  = "#{width.replace(/px/, '')}px"
                height = "#{height.replace(/px/, '')}px"

                angular.element(@container)
                    .css('width'    , width)
                    .css('height'   , height)
                    .css('position' , 'relative')

            show: ->
                # hide image because of preloading it
                @el.css('display', 'none')

                # append to the container
                @spinner.spin(@container[0]);

                # wait until image is loading
                loader = new ImageLoader()
                loader.onload = @hide
                loader.src    = @el.attr('src')

            hide: =>
                @spinner.stop()
                @el.css('display', 'block')

        SPINNER_CLASS_NAME = 'spinner-container'

        isEmpty = (value) ->
            value is undefined or
            value is null or
            value is ''

        link = (scope, element, attributes) ->
            # Wrap img by container with fixed width, height using the img
            # attributes width and height
            container = angular.
                element("<div>").
                addClass(SPINNER_CLASS_NAME)
            element.wrap(container)

            image = angular.element(element)

            render = (src) ->
                return if isEmpty(src) ||
                    isEmpty(image.attr('width')) ||
                    isEmpty(image.attr('height'))

                # In case if user passed hash with setting using
                # image-spinner-settings attribute we will eval it and pass to the
                # spin.js
                settings = attributes.imageSpinnerSettings
                settings ?= {}
                settings = scope.$eval(settings)

                spinner = new SpinnerBuilder(image, settings)
                spinner.show()

            attributes.$observe 'ng-src' , render
            attributes.$observe 'src'    , render

        return {
            link : link
        }
]

