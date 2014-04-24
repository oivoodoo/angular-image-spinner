describe 'imageSpinner', ->
    example = null
    scope   = null
    image   = null

    class ImageMock
        constructor: ->
            image = @

    beforeEach module('imageSpinner')

    beforeEach module ($provide, $injector) ->
        $provide.value '$window', Image: ImageMock
        return

    Example =
        create: ($compile, template) ->
            example = $ """
              <div>
                #{template}
              </div>
            """
            $compile(example)(scope)
            example

    beforeEach inject ($rootScope, $compile) ->
        scope = $rootScope

    describe 'with good img', ->
        beforeEach inject ($rootScope, $compile) ->
            Example.create $compile, """
              <img src='http://www.example.com/bart.jpg' width='100' height='100' image-spinner />
            """
            scope.$digest()
            return

        it 'should be hidden by default on load of the image', ->
            expect(example.find('img').css('display')).toEqual('none')

        it 'should wrap image by container with spinner', ->
            expect(example.find('.spinner-container img').length).toEqual(1)

        it 'should show image on load', ->
            image.onload()
            expect(example
                .find('div')
                .find('img').css('display')
            ).toEqual('block')

        it 'should create the spinner in the container unlil the image is loaded', ->
            expect(example.find('.spinner-container .spinner').length).toEqual(1)

        it 'should hide the spinner in case of loaded image', ->
            image.onload()
            expect(example.find('.spinner-container .spinner').length).toEqual(0)

    describe 'with missing width', ->
        beforeEach inject ($rootScope, $compile) ->
            Example.create $compile, """
              <img src='http://www.example.com/bart.jpg' width='' height='100' image-spinner />
            """
            scope.$digest()
            return

        it 'should not show image spinner', ->
            expect(example.find('.spinner-container .spinner').length).toEqual(0)

    describe 'with missing height', ->
        beforeEach inject ($rootScope, $compile) ->
            Example.create $compile, """
              <img src='http://www.example.com/bart.jpg' width='100' height='' image-spinner />
            """
            scope.$digest()
            return

        it 'should not show image spinner', ->
            expect(example.find('.spinner-container .spinner').length).toEqual(0)

    describe 'with missing src', ->
        beforeEach inject ($rootScope, $compile) ->
            Example.create $compile, """
              <img src='' width='100' height='100' image-spinner />
            """
            scope.$digest()
            return

        it 'should not show image spinner', ->
            expect(example.find('.spinner-container .spinner').length).toEqual(0)

    describe 'with changed src on $digest', ->
        beforeEach inject ($rootScope, $compile) ->
            Example.create $compile, """
              <img ng-src='{{url}}' width='100' height='100' image-spinner />
            """
            scope.$digest()
            return

        it 'should not show image spinner', ->
            scope.url = null
            scope.$digest()
            expect(example.find('.spinner-container .spinner').length).toEqual(0)

        it 'should show image spinner in case of getting on the next digest cycle src', ->
            scope.url = null
            scope.$digest()
            scope.url = 'http://www.example.com/bart.jpg'
            scope.$digest()
            expect(example.find('.spinner-container .spinner').length).toEqual(1)

    describe 'with ng-show directive', ->
        beforeEach inject ($rootScope, $compile) ->
            Example.create $compile, """
              <img ng-show='has' src='http://www.example.com/bart.jpg' width='100' height='100' image-spinner />
            """
            scope.$digest()
            return

        it 'should not show image spinner', ->
            scope.has = false
            scope.$digest()
            expect(example.find('.spinner-container .spinner').length).toEqual(0)
            expect(example
                .find('div')
                .find('img').css('display')
            ).toEqual('none')
            scope.has = true
            scope.$digest()
            expect(example.find('.spinner-container .spinner').length).toEqual(1)

    describe 'with ng-hide directive', ->
        beforeEach inject ($rootScope, $compile) ->
            Example.create $compile, """
              <img ng-hide='!has' src='http://www.example.com/bart.jpg' width='100' height='100' image-spinner />
            """
            scope.$digest()
            return

        it 'should not show image spinner', ->
            scope.has = false
            scope.$digest()
            expect(example.find('.spinner-container .spinner').length).toEqual(0)
            scope.has = true
            scope.$digest()
            expect(example.find('.spinner-container .spinner').length).toEqual(1)

    describe 'with ng-if directive', ->
        beforeEach inject ($rootScope, $compile) ->
            Example.create $compile, """
              <img ng-if='has' src='http://www.example.com/bart.jpg' width='100' height='100' image-spinner />
            """
            scope.$digest()
            return

        it 'should not show image spinner', ->
            scope.has = false
            scope.$digest()
            expect(example.find('.spinner-container .spinner').length).toEqual(0)
            scope.has = true
            scope.$digest()
            expect(example.find('.spinner-container .spinner').length).toEqual(1)

        it 'should not show image spinner', ->
            scope.has = true
            scope.$digest()
            expect(example.find('.spinner-container .spinner').length).toEqual(1)
            scope.has = false
            scope.$digest()
            expect(example.find('.spinner-container .spinner').length).toEqual(0)

    describe 'with bindable width and height', ->
        beforeEach inject ($rootScope, $compile) ->
            Example.create $compile, """
              <img src='http://www.example.com/bart.jpg' width='{{width}}' height='{{height}}' image-spinner />
            """
            scope.$digest()
            return

        it 'should calculate width and height for img', ->
            scope.width  = 5
            scope.height = 5
            scope.$digest()
            expect(example.find('.spinner-container').css('width')).toEqual("5px")
            expect(example.find('.spinner-container').css('height')).toEqual("5px")

