
Given /^the following videos for the serie "([^"]*)", season '(\d+)', capitle '(\d+)'$/ do |serie_title, season, capitle, videos_table|
  capitle = Serie.titled(serie_title).first.capitles.season_capitle(season.to_i, capitle.to_i)
  videos_table.hashes.each do |video_data|
    capitle.videos << Video.create(video_data)
  end
end

Then /^I should see '(\d+)' "([^"]*)" videos available$/ do |video_count, visualization_type|
  selector = "div#capitle_available_videos_panel_container div##{visualization_type}_video_container"
  page.should have_selector(selector) do |visualization_type_video_container|#, :count => video_count.to_i)
    visualization_type_video_container.should have_selector("a.video_link", :count => video_count.to_i)
  end
end