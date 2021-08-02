Feature:CRUD labels
Background:
    * url "https://api.todoist.com/rest/v1/labels"
    * def headerData = { Authorization: ' Bearer c67ef38e5d5268f5874e1ae43230daf905063158'}
    * headers headerData
Scenario:Get all labels
    Given path "/"
    When method Get
    Then status 200
    Then match response == "#array"

Scenario:crud labels
    Given path "/"
    And request
    """
        {
            "name": "Food"
        }
    """
    When method post
    Then status 200
    Then match response == "#object"
    Then match response.name == "Food"
    Then match response.color == "#number"

    * def labelId = response.id

    Given path "/"+labelId
    And header Authorization = accessToken
    When method Get
    Then status 200
    Then match response == "#object"
    Then match response.id == labelId

    Given path "/"+labelId
    And header Authorization = accessToken
    And request
    """
        {
            "name": "Drinks"
        }
    """
    When method post
    Then status 204

    Given path "/"+labelId
    And header Authorization = accessToken
    When method delete
    Then status 204

Scenario:Empty request payload
    Given path "/"
    And request
    """
        {}
    """
    When method post
    Then status 400
    Then match response contains "Empty name"

Scenario:label id does not exists
    Given path "/1"
    When method Get
    Then status 404
    Then match response contains "Not Found"


