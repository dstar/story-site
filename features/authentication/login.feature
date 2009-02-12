Feature: Login
  To ensure the safety of the application
  A regular user of the system
  Must authenticate before using the app

  Scenario Outline: Failed Login
    Given I am not authenticated
    When I go to http://playground.playground.pele.cx/login
    And I fill in "username" with "<mail>"
    And I fill in "password" with "<password>"
    And I press "Log In"
    Then the login request should fail
    Then I should see an error message

    Examples:
      | mail           | password       |
      | not_an_address | nil            |
      | not@not        | 123455         |
      | 123@abc.com    | wrong_paasword |

  Scenario: Successful Login
    Given I am not authenticated
    When I go to http://playground.playground.pele.cx/login
    And I fill in "username" with "dstar"
    And I fill in "password" with "test password"
    And I press "Log In"
    Then the login request should succeed
    Then I should see "Logged in as dstar"