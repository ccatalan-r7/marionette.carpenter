module.exports = (grunt) ->

  grunt.initConfig

    pkg: grunt.file.readJSON('package.json')

    clean:
      src: ['build', 'dist']

    copy:

      images:
        expand: true
        flatten: true
        src: 'assets/images/*'
        dest: 'dist/images'

      css:
        src: 'build/marionette.carpenter.css'
        dest: 'dist/marionette.carpenter.css'

      js:
        expand: true
        nonull: false
        cwd: 'build/'
        src: ['marionette.carpenter.js']
        dest: 'dist/'

    coffee:
      source:
        options:
          sourceMap: true
        expand: true
        cwd: 'src/'
        src: ['**/**.coffee']
        dest: 'build/'
        ext: '.js'

      spec:
        options:
          sourceMap: true
        expand: true
        cwd: 'spec'
        src: ['**/**.coffee']
        dest: 'build/spec/'
        ext: '.js'

    eco:
      compile:
        options:
          amd: true
        expand: true
        cwd: 'src/templates/'
        src: ['*.eco']
        dest: 'build/templates/'
        ext: '.js'

    requirejs:
      source:
        options:
          almond: true
          baseUrl: "build/"
          name: "controllers/table_controller"
          include: ["controllers/table_controller"]
          insertRequire: ["controllers/table_controller"]
          out: "build/marionette.carpenter.js"
          optimize: "none"
          generateSourceMaps: true

      spec:
        options:
          almond: true
          baseUrl: "build/"
          include: ["spec/table_controller_spec.js", "spec/table_view_spec.js"]
          out: "build/spec/specs.js"
          optimize: "none"
          generateSourceMaps: true

    concat:

      # "Fix up" our specs to load everything synchronously
      spec:
        src: ["build/spec/specs.js", "build/spec/require_stub.js"]
        dest: "build/spec/specs.js"

      css:
        src: ["build/css/**.css"]
        dest: "dist/marionette.carpenter.css"

    watch:
      files: ['src/**/**.coffee', 'src/**/**.eco', 'spec/**/**.coffee']
      tasks: ['spec']

    jasmine:
      run:
        options:
          vendor: [
            'bower_components/jquery/dist/jquery.js'
            'bower_components/underscore/underscore.js'
            'bower_components/underscore.string/dist/underscore.string.min.js'
            'bower_components/backbone/backbone.js'
            'bower_components/backbone.marionette/lib/backbone.marionette.js'
            'bower_components/backbone.paginator/dist/backbone.paginator.js'
            'bower_components/cocktail/Cocktail.js'
            'bower_components/jasmine-set/jasmine-set.js'
          ]
          specs: ['build/spec/specs.js']
          summary: true

    sass:
      options:
        includePaths: [
          'bower_components/compass-mixins/lib'
        ]
        sourceMap: false
        style: 'compact'
      build:
        expand: true
        flatten: true
        src: ['./src/sass/*.scss']
        dest: './build/css'
        ext: '.css'

  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-contrib-concat')
  grunt.loadNpmTasks('grunt-eco')
  grunt.loadNpmTasks('grunt-contrib-jasmine')
  grunt.loadNpmTasks('grunt-contrib-watch')
  grunt.loadNpmTasks('grunt-contrib-clean')
  grunt.loadNpmTasks('grunt-sass')
  grunt.loadNpmTasks('grunt-contrib-copy')
  grunt.loadNpmTasks('grunt-eco')
  grunt.loadNpmTasks('grunt-requirejs')

  grunt.registerTask('style', ['clean', 'sass'])
  grunt.registerTask('build', ['clean', 'style', 'coffee', 'eco', 'requirejs', 'concat', 'copy'])
  grunt.registerTask('spec',  ['build', 'jasmine'])
  grunt.registerTask('default', ['build'])
