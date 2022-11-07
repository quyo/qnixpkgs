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
  return tsProject.src().pipe(tsProject()).js.pipe(gulp.dest("dist"));
});

// Task which would just create a copy of images in dist directory
gulp.task("frontend-assets", function () {
  return gulp
    .src([
      "./src/frontend/static/**/*.svg",
      "./src/frontend/static/**/*.webp",
      "./src/frontend/static/**/*.gif",
      "./src/frontend/static/**/*.jpg",
      "./src/frontend/static/**/*.jpeg",
      "./src/frontend/static/**/*.png",
      "./src/frontend/static/**/*.woff",
      "./src/frontend/static/**/*.ttf",
      "./src/frontend/static/**/*.otf",
      "./src/frontend/static/**/*.webm",
      "./src/frontend/static/**/*.avi",
      "./src/frontend/static/**/*.mp4",
      "./src/frontend/static/**/*.mpg",
      "./src/frontend/static/**/*.mpeg",
      "./src/frontend/static/**/*.mkv",
      "./src/frontend/static/**/*.weba",
      "./src/frontend/static/**/*.wav",
      "./src/frontend/static/**/*.mp3",
      "./src/frontend/static/**/*.aac",
      "./src/frontend/static/**/*.ogg",
      "./src/frontend/static/**/*.flac",
      "./src/frontend/static/**/*.pdf",
      "./src/frontend/static/**/*.txt",
      "./src/frontend/static/**/*.rtf",
      "./src/frontend/static/**/*.doc",
      "./src/frontend/static/**/*.docx",
      "./src/frontend/static/**/*.xls",
      "./src/frontend/static/**/*.xlsx",
      "./src/frontend/static/**/*.ppt",
      "./src/frontend/static/**/*.pptx",
      "./src/frontend/static/**/*.odt",
      "./src/frontend/static/**/*.ods",
      "./src/frontend/static/**/*.odp",
      "./src/frontend/static/**/*.json",
    ])
    .pipe(gulp.dest("./dist/frontend/static"));
});

// Task which would just create a copy of views in dist directory
gulp.task("frontend-views", function () {
  return gulp
    .src([
      "./src/frontend/views/**/*.ejs",
      "./src/frontend/views/**/*.html",
      "./src/frontend/views/**/*.htm",
    ])
    .pipe(gulp.dest("./dist/frontend/views"));
});

// The default task which runs at start of the gulpfile.js
//gulp.task("default", gulp.series("clean", "backend", "frontend-assets", "frontend-views"), () => {
//    console.log("Done");
//});
