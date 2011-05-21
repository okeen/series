Feature: Show the different videos for a given apitle

  In order to watch a capitle with the best visualization manner
  As a User
  I want to see the available videos (both streaming and direct download ooptions) for any capitle

  Background: Existing Lost serie with 1 capitle [1,1]
    Given an existing serie "Lost" with description "Weird stuff"
    And the existing capitles for the serie "Lost":
		| title       | season | order |
		| "title11"   | 1      | 1     |
     When I go to the "Lost" serie page
     And I follow "title11"

  Scenario: see two online videos given two existing online videos
    Given the following videos for the serie "Lost", season '1', capitle '1'
        | visualization_type | url                                  |
        | online             | http://www.megavideo.com/?v=FGAGTGND |
        | online             | http://www.megavideo.com/?v=H3FJIOMD |
    Then I should see '2' "online" videos available
    And I should see '0' "download" videos available

  Scenario: see two downloadable videos given two existing downloadable videos
    Given the following videos for the serie "Lost", season '1', capitle '1'
        | visualization_type | url                                   |
        | download           | http://www.megaupload.com/?d=PSSXBTEM |
        | download           | http://www.megaupload.com/?d=BTZAUST7 |
    Then I should see '0' "online" videos available
    And I should see '2' "download" videos available

  Scenario: see two online and 2 downloadable videos given two existing online videos
    Given the following videos for the serie "Lost", season '1', capitle '1'
        | visualization_type | url                                   |
        | download           | http://www.megaupload.com/?d=PSSXBTEM |
        | download           | http://www.megaupload.com/?d=BTZAUST7 |
        | online             | http://www.megavideo.com/?v=FGAGTGND  |
        | online             | http://www.megavideo.com/?v=H3FJIOMD  |
    Then I should see '2' "online" videos available
    And I should see '2' "download" videos available



