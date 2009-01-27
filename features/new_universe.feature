Feature: Creating a new Universe
  To collect related stories
  A user with the site admin permission
  Creates a new Universe

#  Scenario: Invalid Permissions
#    Given I am not authenticated
#    When I go to http://playground.playground.pele.cx/site/new_universe
#    Then I should see "You are not authorized for this action!"

#  Scenario: Logging in (Remove Me)
#    Given I am logged in as "dstar" with password "test password"
#    Then I should see "Logged in as dstar"

  Scenario: Valid Permissions
    Given I am logged in as "dstar" with password "test password"
    When I go to http://playground.playground.pele.cx/
    And I follow "New Universe"
    And I fill in "Universe" with "Test Universe"
    And I fill in "Description" with "Test Universe Description"
    And I press "Create Universe"
    Then I should see a notice message
    And I should see "Universe was successfully created."
    And I should see a level 2 header that says "Test Universe"