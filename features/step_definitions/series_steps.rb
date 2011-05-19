Then /^I should see '(\d+)' series listed$/ do |visible_series_count|
  page.should have_selector("a.serie_link", :count => visible_series_count)
end