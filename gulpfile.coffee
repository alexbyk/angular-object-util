gulp = require 'gulp'
gutil = require 'gulp-util'

coffeelint = require 'gulp-coffeelint'
coffee = require 'gulp-coffee'
uglify = require 'gulp-uglify'
del = require 'del'
runSequence = require 'run-sequence'
ngAnnotate = require 'gulp-ng-annotate'
docco = require 'gulp-docco'


# CONFIG ---------------------------------------------------------

isProd = gutil.env.type is 'prod'

sources =
  coffee: 'src/*.coffee'

# dev and prod will both go to dist for simplicity sake
destinations =
  js: 'dist'


# TASKS -------------------------------------------------------------

gulp.task 'lint', ->
  gulp.src(sources.coffee)
  .pipe(coffeelint())
  .pipe(coffeelint.reporter())

gulp.task 'docco', ->
  gulp.src(sources.coffee)
  .pipe(docco())
  .pipe(gulp.dest('docs'))
#
gulp.task 'release', ->
  gulp.src(sources.coffee)
  .pipe(coffee().on('error', gutil.log))
  .pipe(ngAnnotate())
  .pipe(if isProd then uglify() else gutil.noop())
  .pipe(gulp.dest(destinations.js))

gulp.task 'clean', (cb) ->
  del(['dist/', 'docs/'], cb)

gulp.task 'build', ->
  runSequence 'clean', ['lint', 'docco', 'release']

gulp.task 'default', [
  'build'
]
