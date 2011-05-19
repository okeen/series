Feature: Watch TV series catalog

  In order look for series to watch
  As a User
  I want to navigate through the series catalog

  Before do
    5.times do |t|
        Serie.create(:title => "A"+t.to_s+"title", :description => "A"+t.to_s+"title")
    end
  end

Scenario: see the serie's index page with the catalog listed
    Given I am on the series home page
    Then I should see "Series"
    And I should see '5' series listed
    
