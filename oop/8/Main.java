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
