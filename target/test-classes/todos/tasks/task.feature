@debug
Feature:CRUD tasks
Background:
    * url "https://api.todoist.com/rest/v1/tasks"
    * def headerData = { Authorization: ' Bearer c67ef38e5d5268f5874e1ae43230daf905063158'}
    * headers headerData
Scenario:Get all active tasks
    Given path "/"
    When method Get
    Then status 200
    Then match response == "#array"

Scenario:crud task
    Given path "/"
    And request
    """
        {
            "content": "Buy Milk", "due_string": "tomorrow at 12:00", "due_lang": "en", "priority": 4
        }
    """ 
    When method post
    Then status 200
    Then match response == "#object"
    Then match response.id =="#notnull"
    Then match response.content == "Buy Milk"
    
    * def taskId = response.id

    Given path "/"+taskId
    And header Authorization = accessToken
    When method Get
    Then status 200
    Then match response == "#object"
    Then match response.priority == 4
    Then match response == '#object'
    * string jsonSchemaExpected = read('file:src/test/java/todos/dataSchema.json')
    * string jsonData = response
    * def SchemaUtils = Java.type('todos.JSONSchemaUtil')
    * assert SchemaUtils.isValid(jsonData, jsonSchemaExpected)

    Given path "/"+taskId
    And header Authorization = accessToken
    And request
    """
        {
            "content": "Buy Coffee"
        }
    """
    When method post
    Then status 204

    Given path "/"+taskId+"/close"
    And header Authorization = accessToken
    When method post
    Then status 204

    Given path "/"+taskId+"/reopen"
    And header Authorization = accessToken
    When method post
    Then status 204

    Given path "/"+taskId
    And header Authorization = accessToken
    When method delete
    Then status 204

Scenario:Create task with no content
    Given path "/"
    And request
    """
        {
            "due_string": "tomorrow at 12:00", 
            "due_lang": "en", 
            "priority": 4
        }
    """
    When method post
    Then status 400
    Then match response contains "Empty content"

Scenario:Get task with invalid in
    Given path "/1"
    When method get
    Then status 404
    Then match response contains "Not Found"