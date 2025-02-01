package backend.models.competitor;
import java.util.Arrays;
public class Competitor {
    private int ID;
    private Name CompetitorName;
    private String Level;
    private int Age;
    private int[] Scores;


    public Competitor(String name, int age, int level, int[] scores){
        this.CompetitorName = new Name(name);
        this.Scores = scores != null ? scores : new int[5];

        switch (level){
            case 0:
                this.Level = "Beginner";
                break;
            case 1:
                this.Level = "Intermediate";
                break;
            case 2:
                this.Level = "Expert";
                break;
            default:
                this.Level = "Beginner";
                break;
        }
        this.Age = age;
    }

    public int getCompetitorID(){
        return this.ID;
    }

    public void setCompetitorID(int id){
        this.ID = id;
    }

    public String getCompetitorName(int type){
        // 0: first name
        // 1: last name
        // Default: Full name
        switch (type){
            case 0:
                return CompetitorName.getFName();
            case 1:
                return CompetitorName.getLName();
            case 2:
                return CompetitorName.getInitials();
            default:
                return CompetitorName.getFullName();
        }
    }

    public String getCompetitorLevel(){
        return this.Level; 
    }

    public String getFullDetails(){
        return String.format(
                "Competitor number: %d, Name: %s\n%s is a %s aged %d and has an overall score of %.2f", 
                ID, 
                CompetitorName.getFullName(), 
                CompetitorName.getInitials(),  
                Level, 
                Age, 
                getOverallScore() 
                );
    }


    public int getAge(){
        return this.Age;
    }
    public String getShortDetails(){
        return String.format("CN %d (%s) has overall score of %.2f",ID,CompetitorName.getInitials(),getOverallScore());
    }

    public double getOverallScore(){
        Arrays.sort(Scores);
        double total = 0;
        for (int i = 1; i < Scores.length - 1; i++) { 
            total += Scores[i];
        }
        return total / (Scores.length - 2);
    }
    
    public int[] getScoreArray(){
        return Scores;
    }
}
