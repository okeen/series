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


Then /^I should see the "([^"]*)" catalog results link$/ do |link_id|
  page.should have_selector("a##{link_id}")
end

Then /^I should not see the "([^"]*)" catalog results link$/ do |link_id|
  page.should_not have_selector("a##{link_id}")
end

Given /^an existing serie "([^"]*)" with description "([^"]*)"$/ do |serie_title, serie_description|
  @serie= Serie.create(:title => serie_title, :description => serie_description)
end

Given /^the existing capitles for the serie "([^"]*)":$/ do |serie_title, serie_capitles_table|
  @serie = Serie.where(:title => serie_title).first
  serie_capitles_table.hashes.each do |capitle_data|
    @serie.capitles << Capitle.new(capitle_data)
  end
end

Then /^I should see "([^"]*)" in the serie detail field "([^"]*)"$/ do |detail_value, detail_field_id|
  page.should have_selector("p##{detail_field_id}", :content => detail_value)
end

