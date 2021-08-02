package todos.comments;

import com.intuit.karate.junit5.Karate;

class CommentsRunner {

    @Karate.Test
    Karate testUsers() {
        return Karate.run("comment").relativeTo(getClass());
    }    

}