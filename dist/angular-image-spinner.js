(function () {
  angular.module('imageSpinner', []).value('version', '0.1.4');
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
          var _this = this;
          this.el = el;
          this.settings = settings;
          this.remove = __bind(this.remove, this);
          this.disable = __bind(this.disable, this);
          if (settings == null) {
            settings = {};
          }
          settings = angular.extend(settings, DefaultSettings);
          this.spinner = new Spinner(settings);
          this.container = this.el.parent();
          angular.element(this.container).css('position', 'relative');
          this.loader = new ImageLoader();
          this.loader.onload = function () {
            return _this.disable();
          };
        }
        SpinnerBuilder.prototype.setWidth = function (width) {
          width = '' + width.replace(/px/, '') + 'px';
          return angular.element(this.container).css('width', width);
        };
        SpinnerBuilder.prototype.setHeight = function (height) {
          height = '' + height.replace(/px/, '') + 'px';
          return angular.element(this.container).css('height', height);
        };
        SpinnerBuilder.prototype.show = function () {
          this.loading = true;
          this.loader.src = this.el.attr('src');
          this.el.css('display', 'none');
          return this.spin();
        };
        SpinnerBuilder.prototype.disable = function () {
          this.unspin();
          return this.el.css('display', 'block');
        };
        SpinnerBuilder.prototype.remove = function () {
          return this.unspin();
        };
        SpinnerBuilder.prototype.spin = function () {
          if (this.hasSpinner) {
            return;
          }
          this.hasSpinner = true;
          return this.spinner.spin(this.container[0]);
        };
        SpinnerBuilder.prototype.unspin = function () {
          if (!this.hasSpinner) {
            return;
          }
          this.hasSpinner = false;
          return this.spinner.stop();
        };
        return SpinnerBuilder;
      }();
      SPINNER_CLASS_NAME = 'spinner-container';
      isEmpty = function (value) {
        return value === void 0 || value === null || value === '';
      };
      link = function (scope, element, attributes) {
        var container, image, settings, spinner, _this = this;
        container = angular.element('<div>').addClass(SPINNER_CLASS_NAME);
        element.wrap(container);
        image = angular.element(element);
        settings = attributes.imageSpinnerSettings;
        if (settings == null) {
          settings = {};
        }
        settings = scope.$eval(settings);
        spinner = new SpinnerBuilder(image, settings);
        return function (spinner) {
          var render;
          render = function (src) {
            if (isEmpty(src) || isEmpty(image.attr('width')) || isEmpty(image.attr('height'))) {
              return;
            }
            return spinner.show();
          };
          scope.$watch(function () {
            return !image.hasClass('ng-hide');
          }, function (showable) {
            if (showable == null) {
              return;
            }
            if (showable) {
              return render(image.attr('src'));
            } else {
              return spinner.remove();
            }
          });
          scope.$on('$destroy', function () {
            return spinner.remove();
          });
          attributes.$observe('ng-src', render);
          attributes.$observe('src', render);
          attributes.$observe('width', function (width) {
            if (isEmpty(width)) {
              return;
            }
            spinner.setWidth(width);
            return render(image.attr('src'));
          });
          return attributes.$observe('height', function (height) {
            if (isEmpty(height)) {
              return;
            }
            spinner.setHeight(height);
            return render(image.attr('src'));
          });
        }(spinner);
      };
      return {
        restrict: 'A',
        link: link,
        scope: {}
      };
    }
  ]);
}.call(this));