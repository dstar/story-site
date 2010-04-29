Feature: Chapter Uploads
  In order to make things as easy as possible
  Authors should be able to upload chapters in multiple formats
  So that they can concentrate on writing and not on preparing the file for the site

  Scenario Outline: Uploading a file
    Given I am logged in as "dstar" with password "test password"
    And I have a story "Test Story 2"
    When I go to http://playground.test.pele.cx:4000/
    And I follow "dstar"
    And I follow "Test Story 2"
    And I follow "Add Chapter"
    And I attach the file at "<file>" to "File"
    And I press "Create Chapter"
    Then I should see "Chapter was successfully created."
    And I should see a link to the chapter I just uploaded
    And I should see a draft link to the chapter I just uploaded
    And I should see "DRAFT"

    Examples:
      |               file                    |type|
      |features/test_files/test_chapter_1.txt |Text|
      |features/test_files/test_chapter_1.html|HTML|
      |features/test_files/test_chapter_1.doc |Word|

  Scenario Outline: Verifying the uploaded file was converted correctly
    Given I am logged in as "dstar" with password "test password"
    And I have a story "Test Story 2"
    When I go to http://playground.test.pele.cx:4000/
    And I follow "dstar"
    And I follow "Test Story 2"
    And I follow "Add Chapter"
    And I attach the file at "<file>" to "File"
    And I press "Create Chapter"
    And I follow the <link> to the chapter I just uploaded
    Then I should see "This is test paragraph 1" in the 1st paragraph's text
    And "test paragraph 2" in the 2nd paragraph's text should be emphasized
    And "test paragraph 3" in the 3rd paragraph's text should be emphasized
    And "test " in the 4th paragraph's text should be emphasized
    And "paragraph" in the 4th paragraph's text should not be emphasized
    And " 4" in the 4th paragraph's text should be emphasized
    And "test paragraph 5" in the 5th paragraph's text should be strong
    And "test paragraph 6" in the 6th paragraph's text should be strong

    Examples:
      |link        |               file                    |type|
      |reading link|features/test_files/test_chapter_1.txt |Text|
      |reading link|features/test_files/test_chapter_1.html|HTML|
      |reading link|features/test_files/test_chapter_1.doc |Word|
      | draft link |features/test_files/test_chapter_1.txt |Text|
      | draft link |features/test_files/test_chapter_1.html|HTML|
      | draft link |features/test_files/test_chapter_1.doc |Word|
