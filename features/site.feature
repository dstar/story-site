Feature: Site Main Page
  In order for visitors to understand the site,
  The site main page should be understandable and work

  Scenario: Finding Universes from the Main Page as a guest
    Given I am unauthenticated
    And I have a story "Test Story 1"
    And I have a universe "Test Universe 1"
    When I go to http://playground.playground.pele.cx/
    Then I should see a link named "Test Universe 1" which points to "/universes/show/100"

  Scenario: Finding Universes from the Main Page as an admin
    Given I am logged in as "dstar" with password "test password"
    And I have a story "Test Story 1"
    And I have a universe "Test Universe 1"
    When I go to http://playground.playground.pele.cx/
    Then I should see a link named "Test Universe 1" which points to "/universes/show/100"
