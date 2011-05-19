Given /^'(\d+)' existing series with the letter "([^"]*)"$/ do |serie_count, letter|
  serie_count.to_i.times do |n|
    Serie.create(
      :title => "#{letter}:#{n} title",
      :description => "#{letter}:#{n} description"
    )
  end
end

Then /^I should see '(\d+)' series listed$/ do |visible_series_count|
  #page.should have_selector(:xpath, "a[class='serie_link']")
  page.should have_selector("a.serie_link", :count => visible_series_count.to_i)
end


When /^I click on the "([^"]*)" letter catalog filter link$/ do |catalog_letter|
  within "div#catalogue_filter_letters" do
    click_link catalog_letter
  end
end

Then /^I should see '(\d+)' series listed whose title starts with "([^"]*)"$/ do |series_count, starting_letter|
  got_selector = have_selector("a.serie_link", :content => starting_letter, :count => series_count.to_i)
  series_count != '0' ? page.should(got_selector) : page.should_not(got_selector)
end