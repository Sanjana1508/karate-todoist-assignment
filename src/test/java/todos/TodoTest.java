package todos;

import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import static org.junit.jupiter.api.Assertions.*;
import org.junit.jupiter.api.Test;
import com.intuit.karate.KarateOptions;

@KarateOptions(tags = {"@debug"})
class TodosTest {

    @Test
    void testParallel() {
        Results results = Runner.path("classpath:todos")
                .tags("~@ignore")
                //.outputCucumberJson(true)
                .parallel(5);
        assertEquals(0, results.getFailCount(), results.getErrorMessages());
    }

}
