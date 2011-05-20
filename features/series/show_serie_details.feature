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
   When I go to the "lost" serie main page

  Scenario: See details/info about "Lost" in its page
    Then I should see "Lost" in the serie detail field "serie_title"
    And I should see "Weird stuff" in the serie detail field "serie_description"
    And I should see "Seasons: 4, capitles: 10"

  Scenario: See 'Lost' serie's capitles links grouped by season in independent containers
    Then I should see '4' season containers
    And I should see the following season containers having capitles:
        | season_num | capitles_count |
        | 1          | 3              |
        | 2          | 2              |
        | 3          | 3              |
        | 4          | 2              |

  Scenario: See the correct capitle titles for "Lost"'s capitles within each container
    Then I should see the correct titles for the for the following season capitles:
        | season | capitles |
        | 1      | 3        |
        | 2      | 2        |
        | 3      | 3        |
        | 4      | 2        |

  Scenario: See the correct capitle links for "Lost"'s capitles within each container
    Then I should see the correct links for the for the following season capitles:
        | season | capitles | serie |
        | 1      | 3        | Lost  |
        | 2      | 2        | Lost  |
        | 3      | 3        | Lost  |
        | 4      | 2        | Lost  |


  