// Bootstrap demo

import { Popover } from "bootstrap";

new Popover(document.getElementById("bootstrapDemo") ?? "");

import cheatsheet from "../ext/bootstrap-cheatsheet/cheatsheet";
console.log(cheatsheet);

// jQuery demo

import jQuery from "jquery";
/* eslint-disable */
(<any>window).$ = jQuery;
(<any>window).jQuery = jQuery;
/* eslint-enable */

jQuery(function () {
  $("#jQueryDemo").text("The DOM is now loaded and can be manipulated.");
});

// Typescript demo

import Professor from "./professor";
import Student from "./student";

const professor: Professor = new Professor("James Mathew");

const student: Student = new Student("Rohit Lakhotia", professor);

console.log(student.getFavProfessor());

// NODE_ENV demo

console.log(process.env["NODE_ENV"]);
