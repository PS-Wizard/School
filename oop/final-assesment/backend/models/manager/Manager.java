package backend.models.manager;

import backend.models.competitor.Competitor;
import backend.models.competitor.CompetitorList;
import backend.models.manager.db.DB_API;
import java.util.Scanner;
import javax.swing.JFrame;
import frontend.models.SnakeModel;
import frontend.ui.SnakeGame;
import javax.swing.*;
import java.awt.Color;

public class Manager {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);

        while (true) {
            System.out.println("Choose an option:");
            System.out.println("1. View Report");
            System.out.println("2. Insert Record");
            System.out.println("3. Quit Application");

            int choice = scanner.nextInt();
            scanner.nextLine();

            if (choice == 1) {
                // Code for viewing the report (not implemented yet)
                System.out.println("View Report selected.");
                getReport();

            } else if (choice == 2) {
                // Insert Record logic
                insertRecord(scanner);
            } else if (choice == 3) {
                System.out.println("Exiting application.");
                break;
            } else {
                System.out.println("Invalid choice, please try again.");
            }
        }

        scanner.close();
    }



    private static void insertRecord(Scanner scanner) {
        // Get user input for name, level, and age
        System.out.print("Enter name: ");
        String name = scanner.nextLine();

        System.out.print("Enter level (0: Beginner, 1: Intermediate, 2: Expert): ");
        int level = scanner.nextInt();

        System.out.print("Enter age: ");
        int age = scanner.nextInt();
        scanner.nextLine();  

        Competitor competitor = new Competitor(name, age, level, new int[5]);  

        // Play the game 5 times and collect scores
        for (int scoreCount = 0; scoreCount < 5; scoreCount++) {
            System.out.println("Starting a new game...");

            // Start Snake Game
            startGame(competitor, scoreCount);

            // After game ends, ask if the user is ready for the next score
            if (scoreCount < 4) { // Prompt for next score only for 1 to 4 (not after 5th)
                System.out.print("Ready for score " + (scoreCount + 1) + "? (y/n): ");
                String response = scanner.nextLine();

                if (response.equalsIgnoreCase("n")) {
                    System.out.println("User chose to stop. Ending record.");
                    break;
                } else if (!response.equalsIgnoreCase("y")) {
                    System.out.println("Invalid input, skipping score attempt.");
                    break; // Ends the loop if invalid input (you can adjust logic here if needed)
                }
            }
        }

        // Store competitor data in the database
        storeCompetitor(competitor);
    }

    private static void startGame(Competitor competitor, int scoreIndex) {
        // Create a SnakeModel with custom settings
        SnakeModel model = new SnakeModel(100, 50, Color.GREEN, Color.RED, 20, 20);

        // Create the game window
        JFrame frame = new JFrame("Snake Game");
        SnakeGame game = new SnakeGame(model, frame); // Pass the frame to the game
        frame.add(game);
        frame.pack();
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.setVisible(true);

        // Wait for the game to end
        while (!game.isGameOver()) {
            try {
                Thread.sleep(100);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }

        // Get the final score from the game and store it in the competitor's score array
        int finalScore = game.getFinalScore();
        competitor.getScoreArray()[scoreIndex] = finalScore;

        System.out.println("Game Over! Final Score: " + finalScore);
    }


    private static void storeCompetitor(Competitor competitor) {
        DB_API dbApi = new DB_API("jdbc:mysql://localhost:3306/CompetitionDB", "wizard", "Banana4President");
        dbApi.store(competitor);
        System.out.println("Competitor data stored in the database.");
    }

    private static void getReport() {
        DB_API dbApi = new DB_API("jdbc:mysql://localhost:3306/CompetitionDB", "wizard", "Banana4President");
        CompetitorList competitorList = new CompetitorList();
        dbApi.getAllCompetitors(competitorList);
        System.out.println(competitorList); 
        competitorList.printCompetitorList();
    }


}
