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
gulp.task("ts", function () {
    // we need to exclude the frontend directory since that would be done anyway by webpack
    tsProject.config['exclude'] = ["./src/frontend/**/*.ts"] 
    return tsProject.src().pipe(tsProject()).js.pipe(gulp.dest("dist"));
});

// Task which would just create a copy of ejs files in dist directory
gulp.task("ejs", function () {
    return gulp.src("./src/frontend/**/*.ejs").pipe(gulp.dest("./dist/frontend"));
});

// Task which would just create a copy of css files in dist directory
gulp.task("css", function () {
    return gulp.src("./src/frontend/**/*.css").pipe(gulp.dest("./dist/frontend"));
});

// Task which would just create a copy of image files in dist directory
gulp.task("img", function () {
    return gulp.src("./src/frontend/**/*.jpg").pipe(gulp.dest("./dist/frontend"));
    return gulp.src("./src/frontend/**/*.jpeg").pipe(gulp.dest("./dist/frontend"));
    return gulp.src("./src/frontend/**/*.png").pipe(gulp.dest("./dist/frontend"));
    return gulp.src("./src/frontend/**/*.webp").pipe(gulp.dest("./dist/frontend"));
});

// The default task which runs at start of the gulpfile.js
gulp.task("default", gulp.series("clean", "ts", "ejs", "css", "img"), () => {
    console.log("Done");
});
