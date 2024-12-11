import java.io.FileReader;
import java.util.ArrayList;
import java.util.Scanner;

class Student {
    private int id, age;
    private String name;
    private char grade;

    public Student(int id, String name, int age, char grade) {
        this.id = id;
        this.name = name;
        this.age = age;
        this.grade = grade;
    }

    public char getGrade() {
        return grade;
    }

    public String toString() {
        return String.format("ID: %d, Name: %s, Age: %d, Grade: %c", id, name, age, grade);
    }
}

public class main {
    public static void main(String[] args) {
        ArrayList<Student> students = new ArrayList<>();
        try (Scanner scanner = new Scanner(new FileReader("students.csv"))) {
            while (scanner.hasNextLine()) {
                String line = scanner.nextLine();
                String[] parts = line.split(",");
                int id = Integer.parseInt(parts[0]);
                String name = parts[1];
                int age = Integer.parseInt(parts[2]);
                char grade = parts[3].charAt(0);
                students.add(new Student(id, name, age, grade));
            }
        } catch (Exception e) {
            System.out.println("Error");
        }

        for (int i = 0; i < students.size() - 1; i++) {
            for (int j = 0; j < students.size() - 1 - i; j++) {
                if (students.get(j).getGrade() > students.get(j + 1).getGrade()) {
                    Student temp = students.get(j);
                    students.set(j, students.get(j + 1));
                    students.set(j + 1, temp);
                }
            }
        }

        for (Student s : students) {
            System.out.println(s);
        }
    }
}

