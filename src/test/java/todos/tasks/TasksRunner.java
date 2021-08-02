package todos.tasks;

import com.intuit.karate.junit5.Karate;

class TasksRunner {
    
    @Karate.Test
    Karate testUsers() {
        return Karate.run("task").relativeTo(getClass());
    }    

}