describe 'imageSpinner', ->
    example1 = null
    scope    = null
    image    = null

    class ImageMock
        constructor: ->
            image = @

    beforeEach module('imageSpinner')

    beforeEach module ($provide, $injector) ->
        $provide.value '$window', Image: ImageMock
        return

    beforeEach inject ($rootScope, $compile) ->
        example1 = angular.element """
          <div id='example1'>
              <img src='http://www.example.com/bart.jpg' width='100' height='100' image-spinner />
          </div>
        """

        angular.element(document.querySelector('#example1')).remove()
        document.body.appendChild(example1[0])

        example1 = angular.element(document.querySelector('#example1'))

        scope = $rootScope
        $compile(example1)(scope)
        return

    it 'should be hidden by default on load of the image', ->
        expect(example1.find('img').css('display')).toEqual('none')

    it 'should wrap image by container with spinner', ->
        expect(example1
            .find('div')
            .attr('class')
        ).toEqual('spinner-container')

        expect(example1
            .find('div')
            .find('img').length
        ).toEqual(1)

    it 'should show image on load', ->
        image.onload()
        expect(example1
            .find('div')
            .find('img').css('display')
        ).toEqual('block')

    it 'should create the spinner in the container unlil the image is loaded', ->
        expect(document.querySelector('.spinner-container .spinner')).not.toBe(null)

    it 'should hide the spinner in case of loaded image', ->
        image.onload()
        expect(document.querySelector('.spinner-container .spinner')).toBe(null)

