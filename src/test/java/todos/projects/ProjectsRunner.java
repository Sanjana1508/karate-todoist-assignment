package todos.projects;

import com.intuit.karate.junit5.Karate;

class ProjectsRunner {
    
    @Karate.Test
    Karate testUsers() {
        return Karate.run("project").relativeTo(getClass());
    }    

}