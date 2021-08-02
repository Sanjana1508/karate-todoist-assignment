Feature:CRUD comments
Background:
    * url "https://api.todoist.com/rest/v1/comments"
    * def headerData = { Authorization: ' Bearer c67ef38e5d5268f5874e1ae43230daf905063158'}
    * headers headerData
    * def jsonSchemaExpected = 
    """
        {
           "id":"#number",
           "content":"#string",
           "task_id":"#number",
           "posted":"#string",
           "attachment":{
               "resource_type":"#string",
               "file_url":"#string",
               "file_type":"#string",
               "file_name":"#string",
               "upload_state":"#string"
           }
        }
    """
Scenario:Get all comments
    Given param task_id = taskId
    When method Get
    Then status 200


Scenario:Create a comment
    Given path "/"
    And request
    """
        {
        "task_id": 4925781564,
        "content": "Need one bottle of milk",
        "attachment": {
        "resource_type": "file",
        "file_url": "https://s3.amazonaws.com/domorebetter/Todoist+Setup+Guide.pdf",
        "file_type": "application/pdf",
        "file_name": "File.pdf"
            }
        }
    """
    When method post
    Then status 200
    Then match $ == "#object"
    Then match $.content == "Need one bottle of milk"

    * def commentId = $.id

    Given path "/"+commentId
    And header Authorization = accessToken
    When method Get
    Then status 200
    Then match $ == "#object"
    Then match $.attachment["file_type"] == "application/pdf"
    * match response == jsonSchemaExpected

    Given path "/"+commentId
    And header Authorization = accessToken
    And request
    """
        {
            "content": "Need two bottles of milk"
        }
    """
    When method post
    Then status 204

    Given path "/"+commentId
    And header Authorization = accessToken
    When method delete
    Then status 204

Scenario:Task id is not sent
    Given path "/"
    And request
    """
        {
        "content": "Need one bottle of milk",
        "attachment": {
        "resource_type": "file",
        "file_url": "https://s3.amazonaws.com/domorebetter/Todoist+Setup+Guide.pdf",
        "file_type": "application/pdf",
        "file_name": "File.pdf"
            } 
        }
    """
    When method post
    Then status 400
    Then match response == "#string"
    Then match response contains "Either task_id or project_id should be set"

Scenario:comment id does not exists
    Given path "/1"
    When method Get
    Then status 404
    Then match response contains "Not Found"
Scenario:comment id does not exists
    Given path "/1"
    And request
    """
        {
            "content": "Need groceries"
        } 
    """
    When method post
    Then status 400
    Then match response contains "Note not found"
Scenario:Comment schema is invalid
    Given path "/"
    And request
    """
        {
    "content": "Buy Milk", 
    "due_string": "tomorrow at 12:00", 
    "due_lang": "en", 
    "priority": 4
    }
    """
    When method post
    Then status 400
    Then match response contains "Either task_id or project_id should be set"
    * match response != jsonSchemaExpected