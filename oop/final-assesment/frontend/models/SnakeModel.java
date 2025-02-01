package frontend.models;

import java.awt.Color;

public class SnakeModel {
    private int snakeSpeed; // Speed of the snake (in milliseconds per move)
    private int repaintFrequency; // New repaint frequency (in milliseconds)
    private Color snakeColor; // Color of the snake
    private Color appleColor; // Color of the apple
    private int boardWidth; // Width of the game board
    private int boardHeight; // Height of the game board

    public SnakeModel(int snakeSpeed, int repaintFrequency, Color snakeColor, Color appleColor, int boardWidth, int boardHeight) {
        this.snakeSpeed = snakeSpeed;
        this.repaintFrequency = repaintFrequency;
        this.snakeColor = snakeColor;
        this.appleColor = appleColor;
        this.boardWidth = boardWidth;
        this.boardHeight = boardHeight;
    }

    // Getters
    public int getSnakeSpeed() {
        return snakeSpeed;
    }

    public int getRepaintFrequency() {
        return repaintFrequency;
    }

    public Color getSnakeColor() {
        return snakeColor;
    }

    public Color getAppleColor() {
        return appleColor;
    }

    public int getBoardWidth() {
        return boardWidth;
    }

    public int getBoardHeight() {
        return boardHeight;
    }
}
