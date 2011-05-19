Feature: Paginate catalog listing series unless filtering by letter

  In order to navigate through large amounts of series
  As a User
  I want to see a maximum of N series shown any moment and be able to navigate through more results

  Background: Existing 20 series with the letter "a" and 20 with the letter "b"
    Given '20' existing series with the letter "a"
    And '20' existing series with the letter "b"
    And I am on the series catalog page

  Scenario: Existing 40, see a maximum of 16 series on the catalog page
    Then I should see '16' series listed
    And I should see the "catalog_next_results" catalog results link
    And I should not see the "catalog_previous_results" catalog results link

  Scenario: Existing 40, navigate once to the next results seeing 16 series in the page
    When I follow "catalog_next_results"
    Then I should see '16' series listed
    And I should see the "catalog_next_results" catalog results link
    And I should see the "catalog_previous_results" catalog results link

  Scenario: Existing 40, navigate twice to the next results seeing 8 series in the page
    When I follow "catalog_next_results"
    And I follow "catalog_next_results"
    Then I should see '8' series listed
    And I should not see the "catalog_next_results" catalog results link
    And I should see the "catalog_previous_results" catalog results link

