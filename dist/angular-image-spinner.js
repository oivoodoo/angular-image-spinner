(function () {
  angular.module('imageSpinner', []);
}.call(this));
;
(function () {
  var __bind = function (fn, me) {
    return function () {
      return fn.apply(me, arguments);
    };
  };
  angular.module('imageSpinner').directive('imageSpinner', [
    '$window',
    function ($window) {
      var ImageLoader, SPINNER_CLASS_NAME, SpinnerBuilder, link;
      ImageLoader = $window.Image;
      SpinnerBuilder = function () {
        SpinnerBuilder.prototype.DEFAULT_SETTINGS = {
          lines: 7,
          length: 10,
          width: 2,
          radius: 3,
          corners: 1,
          rotate: 0,
          direction: 1,
          color: '#000',
          speed: 1,
          trail: 10,
          shadow: false,
          hwaccel: false,
          className: 'spinner',
          zIndex: 2000000000,
          top: '40%',
          left: '30%'
        };
        function SpinnerBuilder(el, settings) {
          var height, width;
          this.el = el;
          this.settings = settings;
          this.hide = __bind(this.hide, this);
          if (settings == null) {
            settings = {};
          }
          settings = angular.extend(settings, this.DEFAULT_SETTINGS);
          width = this.el.attr('width') || '100';
          height = this.el.attr('height') || '100';
          width = '' + width.replace(/px/, '') + 'px';
          height = '' + height.replace(/px/, '') + 'px';
          this.container = this.el.parent();
          angular.element(this.container).css('width', width).css('height', height).css('position', 'relative');
          this.spinner = new Spinner(settings);
        }
        SpinnerBuilder.prototype.show = function () {
          var loader;
          this.el.css('display', 'none');
          this.spinner.spin(this.container[0]);
          loader = new ImageLoader();
          loader.onload = this.hide;
          return loader.src = this.el.attr('src');
        };
        SpinnerBuilder.prototype.hide = function () {
          this.spinner.stop();
          return this.el.css('display', 'block');
        };
        return SpinnerBuilder;
      }();
      SPINNER_CLASS_NAME = 'spinner-container';
      link = function (scope, element, attributes) {
        var container, image, settings, spinner;
        container = angular.element('<div>').addClass(SPINNER_CLASS_NAME);
        element.wrap(container);
        image = angular.element(element);
        settings = attributes.imageSpinnerSettings;
        if (settings == null) {
          settings = {};
        }
        settings = scope.$eval(settings);
        spinner = new SpinnerBuilder(image, settings);
        return spinner.show();
      };
      return { link: link };
    }
  ]);
}.call(this));