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

        // Timer to check for game over
        Timer checkGameOverTimer = new Timer(100, e -> {
            if (game.gameOver) {
                frame.dispose();  // Close the window
                ((Timer) e.getSource()).stop();  // Stop this timer
            }
        });
        checkGameOverTimer.start();
    }
}
