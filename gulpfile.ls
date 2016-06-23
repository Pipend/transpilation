require! \browserify
require! \gulp
require! \gulp-livescript
require! \gulp-mocha
{instrument, hook-require, write-reports} = (require \gulp-livescript-istanbul)!
require! \gulp-streamify
require! \gulp-uglify
source = require \vinyl-source-stream

gulp.task \build, ->
    gulp.src <[index.ls]>
    .pipe gulp-livescript!
    .pipe gulp.dest './'

gulp.task \dist, <[build]>, ->
    browserify standalone: \transpilation, debug: false
        .add <[./index.js]>
        .exclude \babel-standalone
        .exclude \livescript-standalone
        .exclude \prelude-ls
        .bundle!
        .pipe source \index.min.js
        .pipe (gulp-streamify gulp-uglify!)
        .pipe gulp.dest \./dist

gulp.task \watch, ->
    gulp.watch <[./index.ls]>, <[build]>

gulp.task \coverage, ->
    gulp.src <[./index.ls]>
    .pipe instrument!
    .pipe hook-require!
    .on \finish, ->
        gulp.src <[./test/index.ls]>
        .pipe gulp-mocha!
        .pipe write-reports!
        .on \finish, -> process.exit!

gulp.task \default, <[build watch]>