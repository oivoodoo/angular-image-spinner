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
            # example3 = createExample 'example3', """
            #   <img src='http://www.example.com/bart.jpg' width='100' height='' image-spinner />
            # """
            # example4 = createExample 'example4', """
            #   <img src='http://www.example.com/bart.jpg' width='' height='100' image-spinner />
            # """
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

    describe 'with missing src', ->
        beforeEach inject ($rootScope, $compile) ->
            Example.create $compile, """
              <img src='' width='100' height='100' image-spinner />
            """
            return

        it 'should not show image spinner', ->
            expect(example.find('.spinner-container .spinner').length).toEqual(0)

