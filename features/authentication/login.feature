Feature: Login
  To ensure the safety of the application
  A regular user of the system
  Must authenticate before using the app

  Scenario: Failed Login
    Given I am not authenticated
    When I go to http://playground.test.pele.cx:4000/login
    And I fill in "username" with "not_a_user"
    And I fill in "password" with "not_a_password"
    And I press "Log In"
    Then the login request should fail
    Then I should see an error message

  Scenario: Successful Login
    Given I am not authenticated
    When I go to http://playground.test.pele.cx:4000/login
    And I fill in "username" with "dstar"
    And I fill in "password" with "test password"
    And I press "Log In"
    Then the login request should succeed
    Then I should see "Logged in as dstar"
