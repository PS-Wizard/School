package frontend;
import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;
import java.util.ArrayList;
import java.util.Random;

import backend.models.Competitor;
import backend.db.DB_API;

public class WordGame extends JPanel implements ActionListener, KeyListener {
    private static final int WIDTH = 1920;
    private static final int HEIGHT = 1080;
    private static final int FALLING_SPEED = 5;
    private static final int INITIAL_DELAY = 50;
    private static final int SCORE_INCREASE_INTERVAL = 2;
    private static final int METEOR_WIDTH = 50; 
    private static final int METEOR_HEIGHT = 50; 

    private Timer timer;
    private ArrayList<String> words;
    private ArrayList<Integer> wordX;
    private ArrayList<Integer> wordY;
    private Random random;
    private int score;
    private int fallingRate;
    private String currentWord;
    private Image backgroundImage;
    private Image meteorImage;
    private Competitor comp;
    private DB_API database;
    private String selected;

    public WordGame(Competitor comp,String selected) {
        this.comp = comp;
        this.selected = selected;
        this.database = new DB_API("jdbc:mysql://localhost:3306/JavaAssessment","wizard","Banana4President");
        setPreferredSize(new Dimension(WIDTH, HEIGHT));
        setFocusable(true);
        addKeyListener(this);

        // Load background image (earth)
        backgroundImage = new ImageIcon("frontend/images.jpg").getImage();

        // Load and resize meteor image
        ImageIcon meteorIcon = new ImageIcon("frontend/meteor.png");
        meteorImage = meteorIcon.getImage().getScaledInstance(METEOR_WIDTH, METEOR_HEIGHT, Image.SCALE_SMOOTH);

        // Initialize game variables
        words = new ArrayList<>();
        wordX = new ArrayList<>();
        wordY = new ArrayList<>();
        random = new Random();
        score = 0;
        fallingRate = FALLING_SPEED;
        currentWord = "";

        // Start the game loop
        timer = new Timer(INITIAL_DELAY, this);
        timer.start();

        // Add the first word
        addWord();
    }

    private void addWord() {
        String[] wordList = {"apple", "banana", "cherry", "date", "elderberry", "fig", "grape", "honeydew"};
        String word = wordList[random.nextInt(wordList.length)];
        words.add(word);
        wordX.add(random.nextInt(WIDTH - 100));
        wordY.add(0);
    }

    @Override
    protected void paintComponent(Graphics g) {
        super.paintComponent(g);
        // Draw background image (earth)
        g.drawImage(backgroundImage, 0, 0, getWidth(), getHeight(), this);

        // Draw words and meteors
        g.setColor(Color.WHITE);
        //Font font = new Font("JetBrains Mono", Font.BOLD, 24);
        //g.setFont(font);
        for (int i = 0; i < words.size(); i++) {
            // Draw meteor image below the word
            g.drawImage(meteorImage, wordX.get(i), wordY.get(i) + 30, null);
            // Draw word
            g.drawString(words.get(i), wordX.get(i), wordY.get(i));
        }

        // Draw score
        g.drawString("Score: " + score, 10, 30);

        // Draw current word being typed
        g.drawString("Type: " + currentWord, 10, HEIGHT - 30);
    }

    @Override
    public void actionPerformed(ActionEvent e) {
        // Move words and meteors down
        for (int i = 0; i < wordY.size(); i++) {
            wordY.set(i, wordY.get(i) + fallingRate);
            if (wordY.get(i) > HEIGHT) {
                gameOver();
                return;
            }
        }

        if (words.contains(currentWord)) {
            int index = words.indexOf(currentWord);
            words.remove(index);
            wordX.remove(index);
            wordY.remove(index);
            score++;
            currentWord = "";

            if (score % SCORE_INCREASE_INTERVAL == 0) {
                fallingRate++;
            }

            addWord();
        }

        repaint();
    }

    private void gameOver() {
        timer.stop();
        int[] scores = comp.getScores();
        int index = -1;

        if (this.selected.equals("S1")) index = 0;
        else if (this.selected.equals("S2")) index = 1;
        else if (this.selected.equals("S3")) index = 2;
        else if (this.selected.equals("S4")) index = 3;
        else if (this.selected.equals("S5")) index = 4;

        if (index != -1) {
            scores[index] = score; 
        }

        database.store(comp);
    }

    @Override
    public void keyTyped(KeyEvent e) {
        char c = e.getKeyChar();
        if (c == KeyEvent.VK_BACK_SPACE && currentWord.length() > 0) {
            currentWord = currentWord.substring(0, currentWord.length() - 1);
        } else if (Character.isLetter(c)) {
            currentWord += c;
        }
        repaint();
    }

    @Override
    public void keyPressed(KeyEvent e) {}

    @Override
    public void keyReleased(KeyEvent e) {}
}
