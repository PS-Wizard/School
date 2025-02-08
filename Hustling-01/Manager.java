import java.util.Scanner;
import java.sql.*;

/**
 * Manages the user interaction cycle for registering users, viewing scores, and administering quiz content.
 * This class provides both user and admin views for interacting with the system.
 */
public class Manager {
    private static database db = new database();
    private static Scanner scanner = new Scanner(System.in);
    private static final String ADMIN_PASSWORD = "Banana4President";

    /**
     * Starts the user input cycle, presenting various options like registering users,
     * viewing scores, or accessing the admin panel.
     */
    public static void startUserInputCycle() {
        while (true) {
            System.out.println("\n1: Register New User");
            System.out.println("2: View Scores");
            System.out.println("3: Quit");
            System.out.println("4: Admin View");
            System.out.print("Select an option: ");

            int choice = scanner.nextInt();
            scanner.nextLine(); // Consume newline

            switch (choice) {
                case 1:
                    registerUser();
                    break;
                case 2:
                    viewScores();
                    break;
                case 3:
                    System.out.println("Exiting program...");
                    return;
                case 4:
                    adminView();
                    break;
                default:
                    System.out.println("Invalid choice, try again!");
            }
        }
    }

    /**
     * Registers a new user by prompting for their name, age, level, and quiz scores.
     * Users can either play the quiz or enter scores manually.
     */
    private static void registerUser() {
        System.out.println("\n1: Play Now");
        System.out.println("2: Enter Scores Only");
        System.out.print("Select an option: ");
        int subChoice = scanner.nextInt();
        scanner.nextLine(); // Consume newline

        if (subChoice == 1) {
            // Initialize scores array to store 5 quiz scores
            int[] scores = new int[5];

            // Loop through 5 quiz rounds
            for (int i = 0; i < 5; i++) {
                System.out.println("\nStarting Round " + (i + 1) + " of the quiz.");
                // Start the quiz game (GUI)
                Questions questions = db.getAllQuestions();
                Quiz quiz = new Quiz(questions);
                quiz.setVisible(true); // This will block until the quiz is closed
                int score = quiz.getFinalScore(); // Now score is correctly retrieved

                // Store the score in the corresponding slot in the scores array
                scores[i] = score;
                System.out.println("You scored " + score + " in this round.");
            }

            // After 5 rounds, ask for user info and store it in the database
            System.out.print("Enter full name: ");
            String name = scanner.nextLine();

            System.out.print("Enter age: ");
            int age = scanner.nextInt();
            scanner.nextLine(); // Consume newline

            System.out.print("Enter level: ");
            String level = scanner.nextLine();

            // Create Competitor object and store the data in the database
            Competitor competitor = new Competitor(name, age, level, scores);
            db.setScores(competitor);
            System.out.println("Competitor registered successfully!");
        } else {
            System.out.println("Play Now feature not implemented yet.");
        }
    }

    /**
     * Allows the user to view scores either for all competitors or a specific competitor.
     */
    private static void viewScores() {
        System.out.println("\n1: Everyone");
        System.out.println("2: Individual");
        System.out.print("Select an option: ");
        int subChoice = scanner.nextInt();
        scanner.nextLine();

        CompetitorList list = db.getScores();

        if (subChoice == 1) {
            list.printCompetitorList();
        } else if (subChoice == 2) {
            System.out.print("Enter competitor ID: ");
            int id = scanner.nextInt();
            scanner.nextLine();

            for (Competitor c : list.getCompetitors()) {
                if (c.getID() == id) {
                    System.out.println("ID: " + c.getID() + ", Name: " + c.getName().getFirstName() + " " + c.getName().getLastName() + ", Level: " + c.getLevel());
                    return;
                }
            }
            System.out.println("Competitor not found!");
        } else {
            System.out.println("Invalid option!");
        }
    }

    /**
     * Allows the admin to view all quiz questions, add new questions, or quit the admin view.
     * Admin access is protected by a password.
     */
    private static void adminView() {
        System.out.print("Enter admin password: ");
        String password = scanner.nextLine();

        if (!ADMIN_PASSWORD.equals(password)) {
            System.out.println("Access Denied: Incorrect Password");
            return;
        }

        while (true) {
            System.out.println("\nAdmin Panel:");
            System.out.println("1: View All Questions");
            System.out.println("2: Set Question");
            System.out.println("3: Quit");
            System.out.print("Select an option: ");

            int choice = scanner.nextInt();
            scanner.nextLine(); // Consume newline

            switch (choice) {
                case 1:
                    Questions questions = db.getAllQuestions();
                    for (Question q : questions.getQuestions()) {
                        System.out.println("Question: " + q.question);
                        System.out.println("Correct Answer: " + q.correctAnswer);
                        System.out.println("Category: " + q.category);
                        System.out.println("Options: " + q.options);
                        System.out.println("-----------------------------");
                    }
                    break;
                case 2:
                    System.out.print("Enter question: ");
                    String question = scanner.nextLine();
                    System.out.print("Enter correct answer: ");
                    String correctAnswer = scanner.nextLine();
                    System.out.print("Enter category: ");
                    String category = scanner.nextLine();
                    System.out.print("Enter options (comma-separated): ");
                    String options = scanner.nextLine();

                    Question newQuestion = new Question(question, correctAnswer, category, options);
                    db.setQuestion(newQuestion);
                    System.out.println("Question added successfully!");
                    break;
                case 3:
                    return;
                default:
                    System.out.println("Invalid option!");
            }
        }
    }
}
