import backend.models.competitor.*;
import backend.models.manager.*;
import backend.models.manager.db.*;

public class Main {
    public static void main(String[] args) {
        Manager.ManageStuff();
        DB_API.Store();
        Competitor.SomeCompetitor();
        CompetitorList.ListOfCompetitors();
        Name.CompetitorInfo();

    }
}
