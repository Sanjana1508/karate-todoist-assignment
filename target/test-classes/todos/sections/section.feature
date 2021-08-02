@debug
Feature:CRUD Sections
Background:
    * url "https://api.todoist.com/rest/v1/sections"
    * def headerData = { Authorization: ' Bearer c67ef38e5d5268f5874e1ae43230daf905063158'}
    * headers headerData
Scenario:Get all sections
    Given param project_id = "2267976326"
    When method Get
    Then status 200

Scenario:crud a section
    Given path "/"
    And request
    """
        {
            "project_id":2267976326,
            "name":"Groceries"
        }
    """
    When method post
    Then status 200
    Then match response == "#object"
    Then match response.name == "Groceries"

    * def sectionId = response.id

    Given path "/"+sectionId
    And header Authorization = accessToken
    When method Get
    Then status 200
    Then match response == "#object"
    Then match response.id == sectionId

    Given path "/"+sectionId
    And header Authorization = accessToken
    And request
    """
        {
            "name":"Supermarket"
        }
    """
    And method post
    Then status 204

    Given path "/"+sectionId
    And header Authorization = accessToken
    And method delete
    Then status 204

Scenario:create section with no project id
    Given path "/"
    And request
    """
        {
            "name":"Groceries"
        }
    """
    When method post
    Then status 400
    Then match response contains "Project id not set"

Scenario:create section with no name
    Given path "/"
    And request
    """
        {
            "project_id":2267976326
        }
    """
    When method post
    Then status 400
    Then match response contains "Empty name"

Scenario:get section with invalid id
    Given path "/1"
    When method get
    Then status 404
    Then match response contains "Not Found"