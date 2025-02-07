package frontend;

import javax.swing.*;
import java.awt.*;
import java.awt.event.*;
import java.util.LinkedList;
import java.util.Random;

public class Snake extends JPanel implements ActionListener, KeyListener {
    private static final int TILE_SIZE = 20;   // Size of each tile
    private static final int WIDTH = 800;      // Width of the game screen
    private static final int HEIGHT = 600;     // Height of the game screen
    private static final int INIT_LENGTH = 3;  // Initial length of the snake
    private static final int SPEED = 50;      // Snake speed (higher means faster)

    private LinkedList<Point> snake;           // Snake body
    private Point apple;                       // Apple position
    private String direction = "RIGHT";        // Direction of snake
    public boolean gameOver = false;          // Game over flag
    private int score = 0;                     // Player's score
    private Timer timer;                       // Timer for game updates

    public Snake() {
        this.setPreferredSize(new Dimension(WIDTH, HEIGHT));
        this.setBackground(Color.BLACK);
        this.setFocusable(true);
        this.addKeyListener(this);
        snake = new LinkedList<>();
        for (int i = 0; i < INIT_LENGTH; i++) {
            snake.add(new Point(INIT_LENGTH - i - 1, 0));  // Start snake in the middle
        }
        spawnApple();
        timer = new Timer(SPEED, this);
        timer.start();
    }

    // Main game loop
    @Override
    public void actionPerformed(ActionEvent e) {
        if (!gameOver) {
            moveSnake();
            checkCollisions();
            repaint();
        }
    }

    // Draw everything on the screen
    @Override
    protected void paintComponent(Graphics g) {
        super.paintComponent(g);

        if (!gameOver) {
            g.setColor(Color.GREEN);
            for (Point p : snake) {
                g.fillRect(p.x * TILE_SIZE, p.y * TILE_SIZE, TILE_SIZE, TILE_SIZE);
            }

            g.setColor(Color.RED);
            g.fillRect(apple.x * TILE_SIZE, apple.y * TILE_SIZE, TILE_SIZE, TILE_SIZE);
        }
    }

    // Handle user key presses
    @Override
    public void keyPressed(KeyEvent e) {
        int code = e.getKeyCode();
        if (code == KeyEvent.VK_UP && !direction.equals("DOWN")) {
            direction = "UP";
        } else if (code == KeyEvent.VK_DOWN && !direction.equals("UP")) {
            direction = "DOWN";
        } else if (code == KeyEvent.VK_LEFT && !direction.equals("RIGHT")) {
            direction = "LEFT";
        } else if (code == KeyEvent.VK_RIGHT && !direction.equals("LEFT")) {
            direction = "RIGHT";
        }
    }

    // Unused KeyListener methods
    @Override
    public void keyReleased(KeyEvent e) {}
    @Override
    public void keyTyped(KeyEvent e) {}

    // Move the snake based on the direction
    private void moveSnake() {
        Point head = snake.getFirst();
        Point newHead = null;

        switch (direction) {
            case "UP":
                newHead = new Point(head.x, head.y - 1);
                break;
            case "DOWN":
                newHead = new Point(head.x, head.y + 1);
                break;
            case "LEFT":
                newHead = new Point(head.x - 1, head.y);
                break;
            case "RIGHT":
                newHead = new Point(head.x + 1, head.y);
                break;
        }

        // Add new head to the snake
        snake.addFirst(newHead);

        // Check if snake eats apple
        if (newHead.equals(apple)) {
            score++;
            spawnApple();
        } else {
            snake.removeLast();  // Remove tail if no apple eaten
        }
    }

    // Spawn the apple at a random location
    private void spawnApple() {
        Random rand = new Random();
        int x = rand.nextInt(WIDTH / TILE_SIZE);
        int y = rand.nextInt(HEIGHT / TILE_SIZE);
        apple = new Point(x, y);
    }

    // Check for collisions (self-collision or wall collision)
    private void checkCollisions() {
        Point head = snake.getFirst();

        // Collision with wall
        if (head.x < 0 || head.x >= WIDTH / TILE_SIZE || head.y < 0 || head.y >= HEIGHT / TILE_SIZE) {
            gameOver = true;
        }

        // Collision with itself
        for (int i = 1; i < snake.size(); i++) {
            if (head.equals(snake.get(i))) {
                gameOver = true;
                break;
            }
        }
    }

    // Get the final score
    public int getScore() {
        return score;
    }

    // Main method to run the game

    public static void main(String[] args) {
        JFrame frame = new JFrame("Snake Game");
        Snake game = new Snake();
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.getContentPane().add(game);
        frame.pack();
        frame.setVisible(true);
        while (!game.gameOver) {
            try {
                Thread.sleep(100);  // Delay to reduce CPU load
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
        // Close the game window after game over
        frame.dispose();

        // Exit the program after the game is over
        System.exit(0);
    }
}
