
Given /^the following videos for the serie "([^"]*)", season '(\d+)', capitle '(\d+)'$/ do |serie_title, season, capitle, videos_table|
  capitle = Serie.titled(serie_title).first.capitles.season_capitle(season.to_i, capitle.to_i)
  videos_table.hashes.each do |video_data|
    puts "Video #{video_data[:url]} #{video_data[:visualization_type]}"
    capitle.videos.create(video_data)
  end
end

Then /^I should see '(\d+)' "([^"]*)" videos available$/ do |video_count, visualization_type|
  selector = "div#capitle_available_videos_panel_container div##{visualization_type}_video_container a.video_link"
  page.should have_selector(selector, :count => video_count.to_i)
end