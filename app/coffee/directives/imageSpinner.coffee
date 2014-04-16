angular.module('imageSpinner')

.directive 'imageSpinner', [
    '$window'
    ($window) ->
        ImageLoader = $window.Image

        class SpinnerBuilder
            DEFAULT_SETTINGS:
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
                top       : '40%'
                left      : '30%'

            constructor: (@el, @settings) ->
                settings ?= {}
                settings = angular.extend(settings, @DEFAULT_SETTINGS)

                width  = @el.attr('width')  || '100'
                height = @el.attr('height') || '100'
                width  = "#{width.replace(/px/, '')}px"
                height = "#{height.replace(/px/, '')}px"

                @container = @el.parent()
                angular.element(@container)
                    .css('width'    , width)
                    .css('height'   , height)
                    .css('position' , 'relative')

                @spinner = new Spinner(settings)

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

        link = (scope, element, attributes) ->
            container = angular.
                element("<div>").
                addClass(SPINNER_CLASS_NAME)
            element.wrap(container)

            image    = angular.element(element)
            settings = attributes.imageSpinnerSettings
            settings ?= {}
            settings = scope.$eval(settings)

            spinner = new SpinnerBuilder(image, settings)
            spinner.show()

        return {
            link : link
        }
]

