Feature: See any specific capitles details

  In order have some information about any capitle so I can know more about it
  As a User
  I want to see a page with information about the capitle

  Background: Existing Lost serie with 1 capitle [1,1]
    Given an existing serie "Lost" with description "Weird stuff"
    And the existing capitles for the serie "Lost":
		| title       | season | order |
		| "title11"   | 1      | 1     |
     When I go to the "Lost" serie page
     And I follow "title11"

@wip
  Scenario: see basic info about the capitle "Lost 1,1" in its index page
    Then I should see "Lost"
    And I should see "season 1"
    And I should see "capitle 1"
    And I should see "title11"