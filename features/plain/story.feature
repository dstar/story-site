Feature: Stories
  In order to have something for people to read,
  Authors should be able to upload and edit Stories

  Scenario: Creating a story
    Given I have an author "dstar"
    And I have a universe "Test Universe 1"
    And I am logged in as "dstar" with password "test password"
    When I go to http://playground.test.pele.cx:4000/
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
    And I should see a link named "Back" which points to "/users/show/3"

  Scenario: Creating a story with valid permissions
    Given I have an author "dstar"
    And I have a universe "Test Universe 1"
    And I do not have a story named "Test Story 1"
    And I am logged in as "dstar" with password "test password"
    When I go to http://playground.test.pele.cx:4000/
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
    And I should see "Keywords: test keywords"
    And I should see a level 2 header that says "Chapters"

  Scenario: Creating a story as a guest
    Given I have a universe "Test Universe 1"
    And I do not have a story named "Test Story 1"
    And I am not authenticated
    When I go to http://playground.test.pele.cx:4000/users/new_story/3
    Then I should see "You are not authorized for this action!"

  Scenario: Creating a story as a guest
    Given I have a universe "Test Universe 1"
    And I do not have a story named "Test Story 1"
    And I am not authenticated
    When I go to http://playground.test.pele.cx:4000/users/new_story/3
    Then I should see "You are not authorized for this action!"

  Scenario: Creating a story with invalid permissions
    Given I have a universe "Test Universe 1"
    And I do not have a story named "Test Story 1"
    And I am logged in as "calvertvl" with password "test password"
    When I go to http://playground.test.pele.cx:4000/users/new_story/3
    Then I should see "You are not authorized for this action!"

  Scenario: Adding a chapter to a story
    Given I am logged in as "dstar" with password "test password"
    And I have a story "Test Story 2"
    When I go to http://playground.test.pele.cx:4000/
    And I follow "dstar"
    And I follow "Test Story 2"
    And I follow "Add Chapter"
    And I attach the file at "features/test_files/test_chapter_1.txt" to "File"
    And I press "Create Chapter"
    Then I should see "Chapter was successfully created."
    And I should see a link named "Part 1" which points to "/html/TS2_1.html"
    And I should see a link named "chapter_1_draft" which points to "/chapters/show_draft/#{TS2_1.html}"
    And I should see "DRAFT"

  Scenario: Adding a chapter to a story with invalid permissions
    Given I am not authenticated
    And I have a story "Test Story 2"
    When I go to http://playground.test.pele.cx:4000/stories/show/102
    Then I should not see a link named "Add Chapter" which points to "/stories/new_chapter/102"

  Scenario: Viewing the chapter
    Given I am logged in as "dstar" with password "test password"
    And I have a story "Test Story 2"
    And the story "Test Story 2" has a chapter with the text in the file at "features/test_files/test_chapter_1.txt"
    When I go to http://playground.test.pele.cx:4000/stories/show/102
    And I follow "Part 1"
    Then I should see "Test Story 2 Chapter 1"

  Scenario: Seeing the draft chapter link
    Given I am logged in as "dstar" with password "test password"
    And I have a story "Test Story 2"
    And the story "Test Story 2" has a chapter with the text in the file at "features/test_files/test_chapter_1.txt"
    When I go to http://playground.test.pele.cx:4000/stories/show/102
    Then I should see an a with attribute "id" set to "chapter_1_draft"

  Scenario: Viewing the chapter as a draft
    Given I am logged in as "dstar" with password "test password"
    And I have a story "Test Story 2"
    And the story "Test Story 2" has a chapter with the text in the file at "features/test_files/test_chapter_1.txt"
    When I go to http://playground.test.pele.cx:4000/stories/show/102
    And I follow "chapter_1_draft"
    Then I should see comment links for "TS2_1.html"
    And I should see "Edit this paragraph"
    And I should see "This is test paragraph 1."

  Scenario: Seeing a paragraph's edit form
    Given I am logged in as "dstar" with password "test password"
    And I have a story "Test Story 2"
    And the story "Test Story 2" has a chapter with the text in the file at "features/test_files/test_chapter_1.txt"
    When I go to http://playground.test.pele.cx:4000/stories/show/102
    And I follow "chapter_1_draft"
    And I follow "Edit this paragraph"
    Then I should see a textarea with attribute "name" set to "paragraph[body_raw]"
    And I should see "This is test paragraph 1."
    And I should see an input with attribute "value" set to "Edit"

  Scenario: Editing a paragraph
    Given I am logged in as "dstar" with password "test password"
    And I have a story "Test Story 2"
    And the story "Test Story 2" has a chapter with the text in the file at "features/test_files/test_chapter_1.txt"
    When I go to http://playground.test.pele.cx:4000/stories/show/102
    And I follow "chapter_1_draft"
    And I follow "Edit this paragraph"
    And I fill in "Body" with "Editing test"
    And I press "Edit"
    Then I should see comment links for "TS2_1.html"
    And I should see "Editing test"

  Scenario: Editing a paragraph into two paragraphs
    Given I am logged in as "dstar" with password "test password"
    And I have a story "Test Story 2"
    And the story "Test Story 2" has a chapter with the text in the file at "features/test_files/test_chapter_1.txt"
    When I go to http://playground.test.pele.cx:4000/stories/show/102
    And I follow "chapter_1_draft"
    And I follow "Edit this paragraph"
    And I fill in "Body" with
      """
      Editing test paragraph 1

      Editing test paragraph 2
      """
    And I press "Edit"
    Then I should see comment links for "TS2_1.html"
    And I should see "Editing test paragraph 1"
    And I should see "Editing test paragraph 2"
    And I should see "Editing test paragraph 2" in the 2nd paragraph's text
    And I should not see "Editing test paragraph 1" in the 2nd paragraph's text
    And I should see "Editing test paragraph 1" in the 1st paragraph's text
    And I should not see "Editing test paragraph 2" in the 1st paragraph's text

  @no-javascript
  Scenario: Deleting a paragraph
    Given I am logged in as "dstar" with password "test password"
    And I have a story "Test Story 2"
    And the story "Test Story 2" has a chapter with the text in the file at "features/test_files/test_chapter_1.txt"
    When I go to http://playground.test.pele.cx:4000/stories/show/102
    And I follow "chapter_1_draft"
    And I follow "Edit this paragraph"
    And I press "Delete Paragraph"
    And I press "Yes"
    Then I should see comment links for "TS2_1.html"
    And I should not see "This is test paragraph 1\."

  @javascript
  Scenario: Deleting a paragraph
    Given I am logged in as "dstar" with password "test password"
    And I have a story "Test Story 2"
    And the story "Test Story 2" has a chapter with the text in the file at "features/test_files/test_chapter_1.txt"
    When I go to http://playground.test.pele.cx:4000/stories/show/102
    And I follow "chapter_1_draft"
    And I follow "Edit this paragraph"
    And I press "Delete Paragraph"
    And I confirm I want to do it
    Then I should see comment links for "TS2_1.html"
    And I should not see "This is test paragraph 1\."
