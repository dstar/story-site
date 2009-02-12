Feature: Stories
  In order to have something for people to read,
  Authors should be able to upload and edit Stories

  Scenario: Creating a story
    Given I have an author "dstar"
    And I have a universe "Test Universe 1"
    And I am logged in as "dstar" with password "test password"
    When I go to http://playground.playground.pele.cx/
    And I follow "dstar"
    And I follow "New Story"
    Then I should see a label with attribute "for" set to "story_title"
    And I should see a label with attribute "for" set to "story_short_title"
    And I should see a label with attribute "for" set to "story_file_prefix"
    And I should see a label with attribute "for" set to "story_keywords"
    And I should see an option with attribute "value" set to "100"
    And I should see a label with attribute "for" set to "story_on_release"
    And I should see a label with attribute "for" set to "story_universe_id"
    And I should see a label with attribute "for" set to "story_description"


  Scenario: Creating a story with valid permissions
    Given I have an author "dstar"
    And I have a universe "Test Universe 1"
    And I do not have a story named "Test Story 1"
    And I am logged in as "dstar" with password "test password"
    When I go to http://playground.playground.pele.cx/
    And I follow "dstar"
    And I follow "New Story"
    And I fill in "Title" with "Test Story 1"
    And I fill in "Short Title" with "ts1"
    And I fill in "File Prefix" with "ts1"
    And I fill in "Keywords" with "test keywords"
    And I select "Test Universe 1" from "Universe"
    And I fill in "Description" with "Test Story Description"
    And I press "Create Story"
    Then the request should succeed
    And I should see "Test Story 1 Web Archive"
    And I should see "Test Story Description"
    And I should see "<p><b>Keywords:</b> test keywords</p>"
    And I should see "<h2>Chapters</h2>"
