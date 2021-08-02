package todos.labels;

import com.intuit.karate.junit5.Karate;

class LabelsRunner {
    
    @Karate.Test
    Karate testUsers() {
        return Karate.run("label").relativeTo(getClass());
    }    

}