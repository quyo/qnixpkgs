import Professor from "./professor";
import Student from "./student";


const professor: Professor = new Professor("James Mathew")

const student: Student = new Student("Rohit Lakhotia", professor)

console.log(student.getFavProfessor())
console.log(process.env.NODE_ENV)
