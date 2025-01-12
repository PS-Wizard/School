# Task 1: Employee Management System
```java
~

import java.util.ArrayList;
import java.util.List;
class Employee {
    private String name;
    private int id;
    private String department;

    public Employee(String name, int id, String department) {
        this.name = name;
        this.id = id;
        this.department = department;
    }

    @Override
    public String toString() {
        return "Employee{name='" + name + "', id=" + id + ", department='" + department + "'}";
    }
}

class EmployeeManager {
    private List<Employee> employees;

    public EmployeeManager() {
        employees = new ArrayList<>();
    }

    public void addEmployee(Employee employee) {
        employees.add(employee);
    }

    public void displayEmployees() {
        for (Employee employee : employees) {
            System.out.println(employee);
        }
    }
}

public class Main{
    public static void main(String[] args) {
        EmployeeManager manager = new EmployeeManager();
        Employee emp1 = new Employee("Alice", 1, "HR");
        Employee emp2 = new Employee("Bob", 2, "Finance");

        manager.addEmployee(emp1);
        manager.addEmployee(emp2);

        System.out.println("employees:");
        manager.displayEmployees();
    } 
}

```
```bash
~
[wizard@archlinux 8]$ git init
[wizard@archlinux 8]$ touch .gitignore SecretKey
[wizard@archlinux 8]$ echo "SecretKey" > .gitignore
[wizard@archlinux 8]$ git add .
[wizard@archlinux 8]$ git commit -m "first change"
[wizard@archlinux 8]$ git push -u origin main.
```

>
## Git Operations:
### What steps would you take to create a new branch for your feature (e.g., feature/add-employee-system)?
```bash
~

[wizard@archlinux 8] git branch <branch_Name>

// To Switch
[wizard@archlinux 8] git checkout <branch_Name>

// Or both at once
git checkout <new_branch_name>
```
>
### How would you add all your files to Git after making changes to the project?
```bash
~

[wizard@archlinux 8] git add .

```
>
### How would you commit your changes to the Git repository with a message explaining the changes?
```bash
~

[wizard@archlinux 8] git commit -m "Some message"
```
>
### How would you push the changes to the remote GitHub repository?
```bash
~

// Pushing and setting the upstream branch:
[wizard@archlinux 8] git push -u origin <branch>

```
>

### Look at history
```bash
~

[wizard@archlinux 8] git log

```
>

### To merge branches
```bash
~

[wizard@archlinux 8] git checkout <main_branch>
[wizard@archlinux 8] git merge <branch_to_merge>
// Resolve any conflicts
[wizard@archlinux 8] git commit -m "some merge"
[wizard@archlinux 8] git push
```
>

