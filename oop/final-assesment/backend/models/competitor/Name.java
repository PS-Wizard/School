package backend.models.competitor;
public class Name{
    String FName;
    String LName;

    public Name(String fullName){
        String[] parts = fullName.split(" ");
        this.FName = parts[0];
        this.LName = parts[1];

    }
    public String getFName(){
        return this.FName;
    }

    public String getLName(){
        return this.LName;
    }

    public String getFullName(){
        return String.format("%s %s",FName, LName);
    }

    public String getInitials(){
        return String.format("%s. %s.",FName.charAt(0),LName.charAt(0));
    }
    
    @Override
    public String toString(){
        return getFullName();
    }
}
