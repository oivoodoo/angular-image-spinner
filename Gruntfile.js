'use strict';

module.exports = function (grunt) {

  // Load grunt tasks automatically
  require('load-grunt-tasks')(grunt);

  // Time how long tasks take. Can help when optimizing build times
  require('time-grunt')(grunt);

  // Define the configuration for all the tasks
  grunt.initConfig({
    // Project settings
    yeoman: {
      // configurable paths
      app: require('./bower.json').appPath || 'app',
      dist: 'dist'
    },

    // Watches files for changes and runs tasks based on the changed files
    watch: {
      js: {
        files: ['<%= yeoman.app %>/scripts/{,*/}*.js']
      },
      coffee: {
        files: [
            '<%= yeoman.app %>/coffee/{,*/}*.coffee',
            '<%= yeoman.app %>/coffee/directives/{,*/}*.coffee',
        ],
        tasks: ['coffee']
      },
      gruntfile: {
        files: ['Gruntfile.js']
      }
    },

    clean: {
      dist: {
        files: [{
          dot: true,
          src: [
            '.tmp',
            '<%= yeoman.dist %>/*',
            '!<%= yeoman.dist %>/.git*'
          ]
        }]
      },
      server: [
          '.tmp',
          'app/scripts/',
      ]
    },

    coffee: {
        compile: {
            files: {
                'app/scripts/app.js'        : 'app/coffee/app.coffee',
                'app/scripts/directives.js' : 'app/coffee/directives/*.coffee'
            }
        }
    },

    concat: {
        options: {
          separator: ';',
        },
        dist: {
          src: ['app/scripts/app.js', 'app/scripts/directives.js'],
          dest: '.tmp/concat/angular-image-spinner.js',
        },
    },

    // Allow the use of non-minsafe AngularJS files. Automatically makes it
    // minsafe compatible so Uglify does not destroy the ng references
    ngmin: {
      dist: {
        files: [{
          expand: true,
          cwd: '.tmp/concat/',
          src: '*.js',
          dest: 'dist/'
        }]
      }
    },

    // Copies remaining files to places other tasks can use
    copy: {
      dist: {
        files: [{
          expand: true,
          dot: true,
          cwd: '<%= yeoman.app %>',
          dest: '<%= yeoman.dist %>',
          src: [
            'bower_components/**/*'
          ]
        }]
      },
    },

    uglify: {
      dist: {
        files: {
          '<%= yeoman.dist %>/angular-image-spinner.min.js': [
            '<%= yeoman.dist %>/angular-image-spinner.js'
          ]
        }
      }
    },

    karma: {
      unit: {
        configFile : 'karma.conf.js',
        singleRun  : true,
        browsers   : ['PhantomJS']
      },
      debug: {
        configFile : 'karma.conf.js',
        singleRun  : false,
        browsers   : ['Chrome']
      }
    }
  });

  grunt.registerTask('test', [
    'clean:server',
    'coffee',
    'karma:unit'
  ]);

  grunt.registerTask('debug', [
    'clean:server',
    'coffee',
    'karma:debug'
  ]);

  grunt.registerTask('build', [
    'clean:dist',
    'coffee',
    'concat',
    'ngmin',
    'copy:dist',
    'uglify'
  ]);

  grunt.registerTask('default', [
    'test',
    'build'
  ]);

  grunt.loadNpmTasks('grunt-shell');
  grunt.loadNpmTasks('grunt-contrib-copy');
  grunt.loadNpmTasks('grunt-karma');
  grunt.loadNpmTasks('grunt-contrib-coffee');
};

