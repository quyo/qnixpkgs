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
gulp.task("backend", function () {
    // we need to exclude the frontend directory since that would be done anyway by webpack
    tsProject.config['exclude'] = ["./src/frontend/**/*.ts"] 
    return tsProject
        .src()
        .pipe(tsProject())
        .js
        .pipe(gulp.dest("dist"));
});

// Task which would just create a copy of images in dist directory
gulp.task("frontend-assets", function () {
    return gulp
        .src([
            "./src/frontend/static/**/*.jpg",
            "./src/frontend/static/**/*.jpeg",
            "./src/frontend/static/**/*.png",
            "./src/frontend/static/**/*.webp"])
        .pipe(gulp.dest("./dist/frontend/static"));
});

// Task which would just create a copy of views in dist directory
gulp.task("frontend-views", function () {
    return gulp
        .src("./src/frontend/views/**/*.ejs")
        .pipe(gulp.dest("./dist/frontend/views"));
});

// The default task which runs at start of the gulpfile.js
//gulp.task("default", gulp.series("clean", "backend", "frontend-assets", "frontend-views"), () => {
//    console.log("Done");
//});
