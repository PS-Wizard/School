import frontend.Snake;
import javax.swing.*;
import java.awt.event.*;

public class Main {
    public static void main(String[] args) {
        Snake game = new Snake();

        // Create a JFrame window to hold the game
        JFrame frame = new JFrame("Snake Game");
        frame.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
        frame.getContentPane().add(game);
        frame.pack();
        frame.setVisible(true);

        // Add a WindowListener to close the game window when it's disposed
        frame.addWindowListener(new WindowAdapter() {
            @Override
            public void windowClosing(WindowEvent e) {
                // This ensures that after the game ends, the window is disposed without using System.exit(0)
                if (game.gameOver) {
                    frame.dispose();  // Close the window
                }
            }
        });

        // Game loop
        while (!game.gameOver) {
            try {
                Thread.sleep(100);  // Delay to reduce CPU load while game is running
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }

        // Final score or any other cleanup can be handled here
        System.out.println("Final Score: " + game.getScore());
    }
}
