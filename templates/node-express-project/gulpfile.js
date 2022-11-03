import gulp from "gulp";
import ts from "gulp-typescript";
import { deleteAsync } from "del";

var tsProject = ts.createProject("tsconfig.json");


// https://rohitlakhotia.com/blog/nodejs-ejs-typescript-using-gulp-webpack/

// Task which would delete the old dist directory if present
gulp.task("clean", function () {
    return deleteAsync(["./dist"]);
});

// Task which would transpile typescript to javascript
gulp.task("typescript", function () {
    // we need to exclude the public/ts directory since that would be done anyway by webpack
    tsProject.config['exclude'] = ["./src/public/ts/**/*"] 
    return tsProject.src().pipe(tsProject()).js.pipe(gulp.dest("dist"));
});

// Task which would just create a copy of the current views directory in dist directory
gulp.task("views", function () {
    return gulp.src("./src/views/**/*.ejs").pipe(gulp.dest("./dist/views"));
});

// Task which would just create a copy of the current static assets directory in dist directory
gulp.task("assets", function () {
    return gulp.src("./src/public/assets/**/*").pipe(gulp.dest("./dist/public/assets"));
});

// The default task which runs at start of the gulpfile.js
gulp.task("default", gulp.series("clean", "typescript", "views", "assets"), () => {
    console.log("Done");
});
