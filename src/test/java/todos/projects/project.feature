Feature:CRUD project
Background:
    * url "https://api.todoist.com/rest/v1"
    * def headerData = { Authorization: ' Bearer c67ef38e5d5268f5874e1ae43230daf905063158'}
    * headers headerData
Scenario:Get all projects
    Given path "/projects"
    When method Get
    Then status 200
    Then match response == "#array"

Scenario:Create a project
    Given path "/projects"
    And request
    """
        {
            "name": "Shopping List"
        }
    """
    When method post
    Then status 200
    Then match response == "#object"
    Then match response.name == "Shopping List"

    * def projectId = response.id

    Given path "/projects/"+projectId
    And header Authorization = accessToken
    When method Get
    Then status 200
    Then match response == "#object"
    Then match response.id == projectId
    Then match response.name == "#notnull"


    Given path "/"+projectId
    When method Get
    Then status 404
    Then match response contains "404 page not found"

    Given path "/projects/"+projectId
    And header Authorization = accessToken
    And request
    """
        {
            "name": "Things To Buy"
        }
    """
    When method post
    Then status 204


    Given path "/projects/"+projectId
    And header Authorization = accessToken
    When method delete
    Then status 204

Scenario:Project with no required field name
    Given path "/"
    And request
    """
        {}
    """
    When method post
    Then status 404

Scenario:project id does not exists
    Given path "/1"
    When method Get
    Then status 404
    Then match response contains "404 page not found"