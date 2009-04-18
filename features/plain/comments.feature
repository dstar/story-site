Feature: Comments
  In order to facilitate proofreading
  Users should be able to comment on paragraphs
  So that the quality of the stories can be improved.

  Scenario: Seeing the comment form
    Given I am logged in as "dstar" with password "test password"
    And I have a story "Test Story 2"
    And the story "Test Story 2" has a chapter with the text in the file at "features/test_files/test_chapter_1.txt"
    When I go to http://playground.test.pele.cx:4000/stories/show/102
    And I follow "chapter_1_draft"
    And I follow "Comment on this paragraph"
    Then I should see a submit button labeled "Create"

  Scenario: Identifying a paragraph
    Given I am logged in as "dstar" with password "test password"
    And I have a story "Test Story 2"
    And the story "Test Story 2" has a chapter with the text in the file at "features/test_files/test_chapter_1.txt"
    When I go to http://playground.test.pele.cx:4000/stories/show/102
    And I follow "chapter_1_draft"
    Then I should see a comment link for the 1st paragraph

  Scenario: Adding a comment as the author
    Given I am logged in as "dstar" with password "test password"
    And I have a story "Test Story 2"
    And the story "Test Story 2" has a chapter with the text in the file at "features/test_files/test_chapter_1.txt"
    When I go to http://playground.test.pele.cx:4000/stories/show/102
    And I follow "chapter_1_draft"
    And I comment on the 1st paragraph
    And I fill in "Comment" with "Test comment"
    And I press "Create"
    Then I should see "Comment on this paragraph"
    And I should see "Test comment"
    And I should see "(Acknowledge)"
    And I should see "(Mark comment as read)"
    And I should see a span with attribute "title" set to "Move comment to previous paragraph"
    And I should see a span with attribute "title" set to "Move comment to next paragraph"
    And I should see a span with attribute "title" set to "Move comments to previous paragraph"
    And I should see a span with attribute "title" set to "Move comments to next paragraph"

  Scenario: Acknowleging a comment
    Given I am logged in as "dstar" with password "test password"
    And I have a story "Test Story 2"
    And the story "Test Story 2" has a chapter with the text in the file at "features/test_files/test_chapter_1.txt"
    When I go to http://playground.test.pele.cx:4000/stories/show/102
    And I follow "chapter_1_draft"
    And I comment on the 1st paragraph
    And I fill in "Comment" with "Test comment"
    And I press "Create"
    And I follow "(Acknowledge)"
    Then I should see "(Un-acknowledge)"
    And I should see "(Mark comment as unread)" in the 1st paragraph's comment block
    And I should see a span with attribute "title" set to "Move comment to previous paragraph"
    And I should see a span with attribute "title" set to "Move comment to next paragraph"
    And I should see a span with attribute "title" set to "Move comments to previous paragraph"
    And I should see a span with attribute "title" set to "Move comments to next paragraph"
    And I should see "Acknowledged by dstar"

  Scenario: Un-acknowleging a comment
    Given I am logged in as "dstar" with password "test password"
    And I have a story "Test Story 2"
    And the story "Test Story 2" has a chapter with the text in the file at "features/test_files/test_chapter_1.txt"
    When I go to http://playground.test.pele.cx:4000/stories/show/102
    And I follow "chapter_1_draft"
    And I comment on the 1st paragraph
    And I fill in "Comment" with "Test comment"
    And I press "Create"
    And I follow "(Acknowledge)"
    And I follow "(Un-acknowledge)"
    Then I should see "(Acknowledge)" in the 1st paragraph's comment block
    And I should see "(Mark comment as read)" in the 1st paragraph's comment block
    And I should see a span with attribute "title" set to "Move comment to previous paragraph"
    And I should see a span with attribute "title" set to "Move comment to next paragraph"
    And I should see a span with attribute "title" set to "Move comments to previous paragraph"
    And I should see a span with attribute "title" set to "Move comments to next paragraph"
    And I should not see "Acknowledged by dstar"

  Scenario: Marking a comment read
    Given I am logged in as "dstar" with password "test password"
    And I have a story "Test Story 2"
    And the story "Test Story 2" has a chapter with the text in the file at "features/test_files/test_chapter_1.txt"
    When I go to http://playground.test.pele.cx:4000/stories/show/102
    And I follow "chapter_1_draft"
    And I comment on the 1st paragraph
    And I fill in "Comment" with "Test comment"
    And I press "Create"
    And I follow "(Mark comment as read)"
    Then I should see "(Acknowledge)"
    And I should see "(Mark comment as unread)" in the 1st paragraph's comment block
    And I should see a span with attribute "title" set to "Move comment to previous paragraph"
    And I should see a span with attribute "title" set to "Move comment to next paragraph"
    And I should see a span with attribute "title" set to "Move comments to previous paragraph"
    And I should see a span with attribute "title" set to "Move comments to next paragraph"
    And I should not see "Acknowledged by dstar"

  Scenario: Marking a comment unread
    Given I am logged in as "dstar" with password "test password"
    And I have a story "Test Story 2"
    And the story "Test Story 2" has a chapter with the text in the file at "features/test_files/test_chapter_1.txt"
    When I go to http://playground.test.pele.cx:4000/stories/show/102
    And I follow "chapter_1_draft"
    And I comment on the 1st paragraph
    And I fill in "Comment" with "Test comment"
    And I press "Create"
    And I follow "(Mark comment as read)"
    And I follow "(Mark comment as unread)"
    Then I should see "(Acknowledge)"
    And I should see "(Mark comment as read)"
    And I should see a span with attribute "title" set to "Move comment to previous paragraph"
    And I should see a span with attribute "title" set to "Move comment to next paragraph"
    And I should see a span with attribute "title" set to "Move comments to previous paragraph"
    And I should see a span with attribute "title" set to "Move comments to next paragraph"
    And I should not see "Acknowledged by dstar"
    And I should not see "(Mark comment as unread)"
