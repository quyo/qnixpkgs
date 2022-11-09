import gulp from "gulp";
import ts from "gulp-typescript";
const { createProject } = ts; // eslint-disable-line import/no-named-as-default-member
import { deleteAsync } from "del";

var tsProject = createProject("tsconfig.json");

// https://rohitlakhotia.com/blog/nodejs-ejs-typescript-using-gulp-webpack/

// Task which would delete the old dist directory if present
gulp.task("clean", function () {
  return deleteAsync(["./dist"]);
});

// Task which would transpile typescript to javascript
gulp.task("backend", function () {
  return tsProject.src().pipe(tsProject()).js.pipe(gulp.dest("dist"));
});

// Task which would just create a copy of asset files in dist directory
gulp.task("frontend-assets", function () {
  return gulp
    .src([
      "./src/frontend/public/**/*",
      "!./src/frontend/public/**/*.{ts,tsx,cts,mts,js,jsx,cjs,mjs,css,scss,sass,less,html,htm}",
    ])
    .pipe(gulp.dest("./dist/frontend/public"));
});

// Task which would just create a copy of views in dist directory
gulp.task("frontend-views", function () {
  return gulp
    .src(["./src/frontend/views/**/*"])
    .pipe(gulp.dest("./dist/frontend/views"));
});

// The default task which runs at start of the gulpfile.js
//gulp.task("default", gulp.series("clean", "backend", "frontend-assets", "frontend-views"), () => {
//    console.log("Done");
//});
