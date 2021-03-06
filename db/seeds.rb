#('a' .. 'z').to_a.each do |letter|
#  rand(20).times do |n|
#    Serie.create(
#      :title => "#{letter}:#{n+1} title",
#      :description => "#{letter}:#{n+1} description"
#    )
#  end
#end
#serie = Serie.first
#5.times do |season|
#  (10+rand(10)).times do |capitle_num|
#    capitle = Capitle.new(:title => "C#{season}_#{capitle_num}", :season => season, :order => capitle_num)
#    serie.capitles << capitle
#
#    (2+rand(8)).times do |video_count|
#      capitle.videos << Video.new(
#              :url => "/videos/#{season},#{capitle_num},#{video_count}",
#              :visualization_type => (rand(2) == 1 ? "online" : "download"))
#    end
#  end
#end

DATA_CSV_FILE = "db/sy-export.csv"

require 'csv'
require 'cgi'
@series = {}
text = File.open(DATA_CSV_FILE).readlines.join "\n"
csv = CSV.parse(text,{:col_sep => ';', :force_quotes => true}) do |capitle_row|
  serie,season, capitle_order, capitle_title, visualization_type, url = capitle_row
  next if serie == "Serie" or serie == nil
  serie.gsub!(".", " ")
  serie.gsub!(",", " ")
  
  #puts serie + "; escaped: #{CGI.escape(serie)}"
  @series[CGI.escape(serie)]||= Serie.create(:title => serie)
  @serie = @series[CGI.escape(serie)]
#   season = temporada.upcase.starts_with?("PRIMERA")? 1:
#            temporada.upcase.starts_with?("SEGUNDA")? 2:
#            temporada.upcase.starts_with?("TERCERA")? 3:
#            temporada.upcase.starts_with?("CUARTA")? 4:
#            temporada.upcase.starts_with?("QUINTA")? 5:
#            temporada.upcase.starts_with?("SEXTA")? 6:
#            temporada.upcase.starts_with?("SEPTIMA")? 7:
#            temporada.upcase.starts_with?("OCTAVA")? 8:
#            temporada.upcase.starts_with?("NOVENA")? 9:
#            temporada.upcase.starts_with?("DECIMA")? 10: 0
  season = season.to_i
  season_capitles = @serie.capitles.for_season(season)
  capitle_order =  capitle_order.to_i
  @capitle = season_capitles.where(:title => capitle_title).first
  @capitle||= @serie.capitles.create(:title => capitle_title, :season => season, :order => (capitle_order))
  video = @capitle.videos.create(:visualization_type => visualization_type, :url => url)
  puts "Created #{@serie.title}: #{@capitle.season}, #{@capitle.order} (#{@capitle.title})"
end
