Feature: Watch TV series catalog

  In order look for series to watch
  As a User
  I want to navigate through the series catalog

  Background: Existing 5 series with letter "a"
    Given '5' existing series with the letter "a"

  Scenario: see the serie's index page with the catalog listed and just 5 series 
    When I go to the series catalog page
    Then I should see "Series"
    And I should see '5' series listed
    
