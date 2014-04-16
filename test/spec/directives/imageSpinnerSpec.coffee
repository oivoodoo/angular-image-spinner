describe 'imageSpinner', ->
    template = null
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
        template = angular.element """
          <div>
              <img src='http://www.example.com/bart.jpg' width='100' height='100' image-spinner />
          </div>
        """
        scope = $rootScope
        $compile(template)(scope)
        return

    it 'should be hidden by default on load of the image', ->
        expect(template.find('img').css('display')).toEqual('none')

    it 'should wrap image by container with spinner', ->
        expect(template.find('div').attr('class')).toEqual('spinner-container')
        expect(template.find('div').find('img').length).toEqual(1)

    it 'should show image on load', ->
        image.onload()
        expect(template.find('div').find('img').css('display')).toEqual('block')

