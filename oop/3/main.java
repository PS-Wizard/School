import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

class User {
    private String fname;
    private String number;
    private String password;
    private String dob;

    public void setField(String field, String value) {
        switch (field) {
            case "fname" -> this.fname = value;
            case "number" -> this.number = value;
            case "password" -> this.password = value;
            case "dob" -> this.dob = value;
        }
    }

    @Override
    public String toString() {
        return String.format( "User's name: %s, User's number: %s, User's password: %s, User's birth date: %s", this.fname, this.number, this.password, this.dob);
    }
}

class Signup {
    public static boolean validateField(String fieldName, String value) {
        return switch (fieldName) {
            case "fname" -> value.length() > 4; 
            case "number" -> value.matches("0\\d{9}"); 
            case "password" -> value.matches("[A-Z].*[@&].*\\d$");
            case "dob" -> {
                if (!value.matches("\\d{2}/\\d{2}/\\d{4}")) {
                    yield false; 
                }
                int birthYear = Integer.parseInt(value.split("/")[2]);
                yield (2024 - birthYear) >= 21; 
            }
            default -> false;
        };
    }
}

public class main {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        List<User> allUsers = new ArrayList<>();
        String[] fields = {"fname", "number", "password", "dob"};

        while (true) {
            User user = new User();
            for (String field : fields) {
                while (true) {
                    System.out.print(String.format("Enter %s: ",field));
                    String input = scanner.nextLine();

                    if (field.equals("password")) {
                        System.out.print("Confirm password: ");
                        String confirmPassword = scanner.nextLine();
                        if (!input.equals(confirmPassword)) {
                            System.out.println("Passwords do not match. Try again.");
                            continue;
                        }
                    }

                    if (Signup.validateField(field, input)) {
                        user.setField(field, input);
                        break;
                    } else {
                        System.out.println("Invalid " + field + ". Please try again.");
                    }
                }
            }

            allUsers.add(user);
            System.out.println("User created: " + user);

            System.out.print("Sign Up Another? y/n: ");
            String choice = scanner.nextLine();

            if (!choice.equalsIgnoreCase("y")) {
                break;
            }
        }

        System.out.println("All Users:");
        for (User u : allUsers) {
            System.out.println(u);
        }

        scanner.close();
    }
}

