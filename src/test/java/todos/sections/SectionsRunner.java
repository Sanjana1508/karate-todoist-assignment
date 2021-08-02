package todos.sections;

import com.intuit.karate.junit5.Karate;

class SectionsRunner {
    
    @Karate.Test
    Karate testUsers() {
        return Karate.run("section").relativeTo(getClass());
    }    

}