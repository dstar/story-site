Feature: Users
  In order to control access to stories
  Visitors should be able to create and maintain accounts

  Scenario: Viewing stories from the user page
    Given I am logged in as "dstar" with password "test password"
    And I have a story "Test Story 2"
    When I go to http://playground.test.pele.cx:4000/
    And I follow "dstar"
    Then I should see "Test Story 2"

  Scenario: Viewing stories from the user page as a guest
    Given I am not authenticated
    And I have a story "Test Story 2"
    When I go to http://playground.test.pele.cx:4000/users/show/3
    Then I should not see "Test Story 2"
    And I should see "Oops"
