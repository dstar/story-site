Feature: Blogposts
  In order to keep readers up to date with site news,
  Users with blogger privileges should be able to create and edit blogposts.

  Scenario: Seeing the archive link
    Given I have at least 10 blogposts
    When I go to http://playground.test.pele.cx:4000/
    Then I should see a link named "Older News" which points to "/blogposts/archive/2"

  Scenario: Following the archive link
    Given I have at least 10 blogposts
    When I go to http://playground.test.pele.cx:4000/
    And I follow "Older News"
    Then I should see "News Archive"

  Scenario: Attempting to create a blogpost with Invalid Permissions
    Given I am not authenticated
    When I go to http://playground.test.pele.cx:4000/blogposts/new
    Then I should see "You are not authorized for this action!"

  Scenario: Seeing the new blogpost link
    Given I am logged in as "dstar" with password "test password"
    When I go to http://playground.test.pele.cx:4000/
    Then I should see "Logged in as dstar"
    And I should see "New blogpost"

  Scenario: Attempting to create a blogpost with Valid Permissions
    Given I am logged in as "dstar" with password "test password"
    When I go to http://playground.test.pele.cx:4000/
    And I follow "New blogpost"
    And I fill in "Title" with "Test Blogpost"
    And I fill in "Body" with "Test Blogpost Body"
    And I press "Create"
    Then the create request should succeed
    And I should see "Blogpost was successfully created."
    And I should see "Test Blogpost"
    And I should see "Test Blogpost Body"

  Scenario: Attempting to edit a blogpost with Valid Permissions
    Given I am logged in as "dstar" with password "test password"
    When I go to http://playground.test.pele.cx:4000/
    And I follow "Edit Blogpost"
    And I fill in "Title" with "Test Blogpost Edit"
    And I fill in "Body" with "Test Blogpost Body Edit"
    And I press "Edit"
    Then the edit request should succeed
    And I should see "Blogpost was successfully updated."
    And I should see "Test Blogpost Edit"
    And I should see "Test Blogpost Body Edit"

  Scenario: Not seeing blogpost edit links with invalid Permissions
    Given I am not authenticated
    When I go to http://playground.test.pele.cx:4000/blogposts/
    Then I should not see a link named "Edit Blogpost"
