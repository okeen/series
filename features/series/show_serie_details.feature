Feature: Show serie details page, with its info and available capitles ordered by season

  In order know everything about my favourite series and watch the capitles
  As a User
  I want to see detailed info about the series and a list of available capitles ordered by season

  Background: Existing serie "Lost" with 4 seasons and the capitles above
  Given an existing serie "Lost" with description "Weird stuff"
  And the existing capitles for the serie "Lost":
		| title       | season | order |
		| "title11"   | 1      | 1     |
		| "title12"   | 1      | 2     |
		| "title13"   | 1      | 3     |
		| "title21"   | 2      | 1     |
		| "title22"   | 2      | 2     |
		| "title31"   | 3      | 1     |
		| "title32"   | 3      | 2     |
		| "title33"   | 3      | 3     |
		| "title41"   | 4      | 1     |
		| "title42"   | 4      | 2     |

@wip
  Scenario: See details/info about "Lost" in its page
    When I go to the "lost" serie main page
    Then I should see "Lost" in the serie detail field "serie_title"
    And I should see "Weird stuff" in the serie detail field "serie_description"
    And I should see "4 seasons"
    