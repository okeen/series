Feature: Filter TV series catalog by serie's title first letter

  In order to easily find the series I am interested in
  As a User
  I want to filter the series to show by their titles first letter

  Background: Existing 5 series with the letter "a", and 6 with the letter "b"
    Given '5' existing series with the letter "a"
    And '6' existing series with the letter "b"
    And I am on the series catalog page

  Scenario Outline: filter series catalog by letters
    When I click on the "<letter>" letter catalog filter link
    Then I should see "Series"
    And I should see '<total_series>' series listed
    And I should see '<a_series_count>' series listed whose title starts with "<letter>"
    And I should see '<b_series_count>' series listed whose title starts with "<letter>"

    Scenarios:all numbers correct
    | letter | total_series | a_series_count | b_series_count |
    | A      | 5            | 5              | 0              |
    | B      | 6            | 0              | 6              |
