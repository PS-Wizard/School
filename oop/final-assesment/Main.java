import backend.db.DB_API;
import backend.model.Game;
public class Main {
    public static void main(String[] args) {
        System.out.println("Hello World");
        Game.startGame();
        System.out.println(Game.getScore());
        DB_API.saveScore(69);
    }
}
