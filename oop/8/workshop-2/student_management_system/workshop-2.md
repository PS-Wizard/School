## Initializing a Git Repository: 
```bash
~
//1
[wizard@archlinux student_management_system]$ git init
[wizard@archlinux student_management_system]$ touch Main.java
[wizard@archlinux student_management_system]$ git add .
// 2.
[wizard@archlinux student_management_system]$ touch Student.java
[wizard@archlinux student_management_system]$ git add .
// 3. Changes were made getter and setter
[wizard@archlinux student_management_system]$ git add .
[wizard@archlinux student_management_system]$ git commit -m "added getter setters"
// 4.
[wizard@archlinux student_management_system]$ touch grade-calculator.java
[wizard@archlinux student_management_system]$ git branch new_grade_calculator
[wizard@archlinux student_management_system]$ git checkout new_grade_calculator

// 5.
[wizard@archlinux student_management_system]$ git add .
[wizard@archlinux student_management_system]$ git commit -m "added grade calculator"
[wizard@archlinux student_management_system]$ git push -u origin new_grade_calculator
[wizard@archlinux student_management_system]$ git push -u origin new_grade_calculator

// 6.

[wizard@archlinux student_management_system]$ git clone https://github.com/ramlal/hck-w7 

```
[Github Repo](https://github.com/PS-Wizard/School/tree/main/oop/8)
