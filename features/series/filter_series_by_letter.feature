Feature: Filter TV series catalog by serie's title first letter

  In order to easily find the series I am interested in
  As a User
  I want to filter the series to show by their titles first letter

  Background: Existing 5 series with the letter "a", and 6 with the letter "b"
    Given '5' existing series with the letter "a"
    And '6' existing series with the letter "b"
    And I am on the series catalog page

@wip
  Scenario: filter the serie by the 'a' letter
    When I click on the "A" letter catalog filter link
    Then I should see "Series"
    And I should see '5' series listed
    And I should see '5' series listed whose title starts with 'a'
    And I should see '0' series listed whose title starts with 'b'
