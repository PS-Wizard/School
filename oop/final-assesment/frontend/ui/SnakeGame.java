package frontend.ui;

import frontend.models.SnakeModel;
import javax.swing.*;
import java.awt.*;
import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;
import java.util.LinkedList;
import java.util.Random;

public class SnakeGame extends JPanel implements KeyListener {
    private final SnakeModel model;
    private final int tileSize;
    private final int boardWidth;
    private final int boardHeight;
    private final LinkedList<Point> snake; // Snake body
    private Point apple; // Apple position
    private int direction; // 0: up, 1: right, 2: down, 3: left
    private boolean isGameOver;
    private int score;
    private JFrame gameFrame; // Reference to the game window

    public SnakeGame(SnakeModel model, JFrame frame) {
        this.model = model;
        this.tileSize = 20; // Size of each tile
        this.boardWidth = model.getBoardWidth();
        this.boardHeight = model.getBoardHeight();
        this.snake = new LinkedList<>();
        this.direction = 1; // Start moving right
        this.isGameOver = false;
        this.score = 0;
        this.gameFrame = frame; // Store the reference to the game window

        // Initialize snake
        snake.add(new Point(5, 5)); // Starting position
        spawnApple();

        // Set up the game window
        setPreferredSize(new Dimension(boardWidth * tileSize, boardHeight * tileSize));
        setBackground(Color.BLACK);
        setFocusable(true);
        addKeyListener(this);

        // Start the game loop
        startGame();
    }

    private void startGame() {
        Timer gameTimer = new Timer(model.getSnakeSpeed(), e -> {
            if (!isGameOver) {
                moveSnake();
                checkCollisions();
                repaint();
            } else {
                gameFrame.dispose();
            }
        });
        Timer repaintTimer = new Timer(model.getRepaintFrequency(), e -> repaint());
        gameTimer.start();
        repaintTimer.start();
    }
    private void moveSnake() {
        Point head = snake.getFirst();
        Point newHead = new Point(head);

        switch (direction) {
            case 0 -> newHead.y--; // Up
            case 1 -> newHead.x++; // Right
            case 2 -> newHead.y++; // Down
            case 3 -> newHead.x--; // Left
        }

        snake.addFirst(newHead);
        if (!newHead.equals(apple)) {
            snake.removeLast(); // Remove tail if no apple eaten
        } else {
            spawnApple();
            score++;
        }
    }

    private void spawnApple() {
        Random random = new Random();
        int x = random.nextInt(boardWidth);
        int y = random.nextInt(boardHeight);
        apple = new Point(x, y);

        // Ensure apple doesn't spawn on the snake
        while (snake.contains(apple)) {
            x = random.nextInt(boardWidth);
            y = random.nextInt(boardHeight);
            apple = new Point(x, y);
        }
    }

    private void checkCollisions() {
        Point head = snake.getFirst();

        // Check wall collision
        if (head.x < 0 || head.x >= boardWidth || head.y < 0 || head.y >= boardHeight) {
            isGameOver = true;
        }

        // Check self-collision
        for (int i = 1; i < snake.size(); i++) {
            if (head.equals(snake.get(i))) {
                isGameOver = true;
                break;
            }
        }
    }

    @Override
    protected void paintComponent(Graphics g) {
        super.paintComponent(g);

        // Draw snake
        g.setColor(model.getSnakeColor());
        for (Point p : snake) {
            g.fillRect(p.x * tileSize, p.y * tileSize, tileSize, tileSize);
        }

        // Draw apple
        g.setColor(model.getAppleColor());
        g.fillOval(apple.x * tileSize, apple.y * tileSize, tileSize, tileSize);
    }

    @Override
    public void keyPressed(KeyEvent e) {
        int key = e.getKeyCode();

        // Change direction (prevent reversing)
        if (key == KeyEvent.VK_UP && direction != 2) direction = 0;
        else if (key == KeyEvent.VK_RIGHT && direction != 3) direction = 1;
        else if (key == KeyEvent.VK_DOWN && direction != 0) direction = 2;
        else if (key == KeyEvent.VK_LEFT && direction != 1) direction = 3;
    }

    @Override
    public void keyReleased(KeyEvent e) {}

    @Override
    public void keyTyped(KeyEvent e) {}

    public int getFinalScore() {
        return score;
    }

    public boolean isGameOver() {
        return isGameOver;
    }
}
