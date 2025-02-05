import java.util.Scanner;
public class Manager {
    private static database db = new database();
    private static Scanner scanner = new Scanner(System.in);

    public static void startUserInputCycle() {
        while (true) {
            System.out.println("\n1: Register New User");
            System.out.println("2: View Scores");
            System.out.println("3: Quit");
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
                default:
                    System.out.println("Invalid choice, try again!");
            }
        }
    }

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
                Quiz quiz = new Quiz();
                // Get the score from the Quiz game after submission
                int score = quiz.getScore();

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
}
