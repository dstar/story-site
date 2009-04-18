Feature: Universes
  In order to organize Stories in a logical manner,
  Authors should be able to collect related Stories into Universes

  Scenario: Attempting to create a Universe with Invalid Permissions
    Given I am not authenticated
    When I go to http://playground.test.pele.cx:4000/site/new_universe
    Then I should see "You are not authorized for this action!"

  Scenario: Attempting to create a Universe with Valid Permissions
    Given I am logged in as "dstar" with password "test password"
    When I go to http://playground.test.pele.cx:4000/
    And I follow "New Universe"
    And I fill in "Name" with "Test Universe"
    And I fill in "Description" with "Test Universe Description"
    And I press "Create Universe"
    Then the create request should succeed
    And I should see "Universe was successfully created."
    And I should see a level 2 header that says "Test Universe"

  Scenario: Attempting to add a Story to a Universe with Invalid Permissions
    Given I am not authenticated
    And I have a story "Test Story 2"
    And I have a universe "Test Universe 1"
    When I go to http://playground.test.pele.cx:4000/universes/add_story/100
    Then I should see "You are not authorized for this action!"

  Scenario: Attempting to add a Story to a Universe with Valid Permissions
    Given I am logged in as "dstar" with password "test password"
    And I have a story "Test Story 2"
    And I have a universe "Test Universe 1"
    When I go to http://playground.test.pele.cx:4000/
    And I follow "Test Universe 1"
    Then I should see "Add Story"
    And the request should succeed

  Scenario: Attempting to add a Story to a Universe with Valid Permissions
    Given I am logged in as "dstar" with password "test password"
    And I have a story "Test Story 2"
    And I have a universe "Test Universe 1"
    When I go to http://playground.test.pele.cx:4000/
    And I follow "Test Universe 1"
    And I follow "Add Story"
    Then I should see "Add story"
    And I should see "Title"
    And I should see "Short Title"

  Scenario: Attempting to add a Story to a Universe by title
    Given I am logged in as "dstar" with password "test password"
    And I have a story "Test Story 2"
    And I have a universe "Test Universe 1"
    When I go to http://playground.test.pele.cx:4000/universes/add_story/100
    And I fill in "title" with "Test Story 2"
    And I press "Add Story"
    Then I should see "Test Story 2 was successfully added."
    And I should see a level 4 header that says "Test Story 2"

  Scenario: Attempting to add a Story to a Universe by short_title
    Given I am logged in as "dstar" with password "test password"
    And I have a story "Test Story 2"
    And I have a universe "Test Universe 1"
    When I go to http://playground.test.pele.cx:4000/universes/add_story/100
    And I fill in "short_title" with "TS2"
    And I press "Add Story"
    Then I should see "Test Story 2 was successfully added."
    And I should see a level 4 header that says "Test Story 2"

  Scenario: Attempting to add a Story to a Universe by title but with an incorrect title
    Given I am logged in as "dstar" with password "test password"
    And I have a story "Test Story 2"
    And I have a universe "Test Universe 1"
    When I go to http://playground.test.pele.cx:4000/universes/add_story/100
    And I fill in "title" with "wrong title"
    And I press "Add Story"
    Then I should see "Could not find story with title 'wrong title'."

  Scenario: Attempting to add a Story to a Universe by short_title but with an incorrect short title
    Given I am logged in as "dstar" with password "test password"
    And I have a story "Test Story 2"
    And I have a universe "Test Universe 1"
    When I go to http://playground.test.pele.cx:4000/universes/add_story/100
    And I fill in "short_title" with "wrong title"
    And I press "Add Story"
    Then I should see "Could not find story with short title 'wrong title'."

  Scenario: Attempting to edit a Universe with invalid permissions
    Given I am not authenticated
    And I have a universe "Test Universe 1"
    When I go to http://playground.test.pele.cx:4000/universes/edit/100
    Then I should see "You are not authorized for this action!"

  Scenario: Attempting to edit a Universe
    Given I am logged in as "dstar" with password "test password"
    And I have a universe "Test Universe 1"
    When I go to http://playground.test.pele.cx:4000/universes/edit/100
    Then I should see an input with attribute "name" set to "universe[name]"
    Then I should see a textarea with attribute "name" set to "universe[description]"
