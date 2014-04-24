(function () {
  angular.module('imageSpinner', []).value('version', '0.0.5');
}.call(this));
;
(function () {
  var __bind = function (fn, me) {
    return function () {
      return fn.apply(me, arguments);
    };
  };
  angular.module('imageSpinner').constant('imageSpinnerDefaultSettings', {
    lines: 9,
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
    top: '50%',
    left: '50%'
  }).directive('imageSpinner', [
    '$window',
    'imageSpinnerDefaultSettings',
    function ($window, DefaultSettings) {
      var ImageLoader, SPINNER_CLASS_NAME, SpinnerBuilder, isEmpty, link;
      ImageLoader = $window.Image;
      SpinnerBuilder = function () {
        function SpinnerBuilder(el, settings) {
          this.el = el;
          this.settings = settings;
          this.hide = __bind(this.hide, this);
          if (settings == null) {
            settings = {};
          }
          settings = angular.extend(settings, DefaultSettings);
          this.spinner = new Spinner(settings);
          this.container = this.el.parent();
          this.setContainerSize();
        }
        SpinnerBuilder.prototype.setContainerSize = function () {
          var height, width;
          width = this.el.attr('width') || '100';
          height = this.el.attr('height') || '100';
          width = '' + width.replace(/px/, '') + 'px';
          height = '' + height.replace(/px/, '') + 'px';
          return angular.element(this.container).css('width', width).css('height', height).css('position', 'relative');
        };
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
      isEmpty = function (value) {
        return value === void 0 || value === null || value === '';
      };
      link = function (scope, element, attributes) {
        var container, image, render;
        container = angular.element('<div>').addClass(SPINNER_CLASS_NAME);
        element.wrap(container);
        image = angular.element(element);
        render = function (src) {
          var settings, spinner;
          if (isEmpty(src) || isEmpty(image.attr('width')) || isEmpty(image.attr('height'))) {
            return;
          }
          settings = attributes.imageSpinnerSettings;
          if (settings == null) {
            settings = {};
          }
          settings = scope.$eval(settings);
          spinner = new SpinnerBuilder(image, settings);
          return spinner.show();
        };
        attributes.$observe('ng-src', render);
        return attributes.$observe('src', render);
      };
      return { link: link };
    }
  ]);
}.call(this));