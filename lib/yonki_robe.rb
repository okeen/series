require 'open-uri'
require 'hpricot'
require 'thread'
require 'csv'

class SerieCapitlesVideoLinksGrabber

  @@mutex = Mutex.new
  @@user_agent="Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/534.36 (KHTML, like Gecko) Chrome/13.0.766.0 Safari/534.36"
  
  def initialize(serie, season = nil, capitle = nil)
    raise "No serie especified, exiting job" unless serie
    @serie, @season, @capitle= [serie, season, capitle]
    @season = @season.to_i if @season
    @capitle = @capitle.to_i if @capitle
    
    @capitles= {}
    puts "New LinkGrabber job created for #{self}"
  end
  
  def do_job
    init
    get_capitles_links
    
    puts "Job done: #{self}"
  end
  
  #all the page link parsing job gets done here
  def get_capitles_links
    @links = []
    @seasons_to_get = get_seasons_to_download    
    @seasons_to_get.each do |season_number|
      unless season_number
	puts "Season not found for #{@serie[:title]}"
	next
      end
      season_capitle_links = get_capitle_links_for_season(season_number)
      season_capitles_and_video_links = [];
      season_capitle_links .each do |capitle|
	capitle_videos_links = get_capitle_video_links(capitle)
	season_capitles_and_video_links << {
	  :serie => @serie[:title],
	  :season => capitle[:season].to_i,
	  :order => capitle[:order],
	  :videos => capitle_videos_links	,
	  :title => capitle[:capitle]
	
	}	
      end
      @links[season_number.to_i]= season_capitles_and_video_links ; 
      persist_season_data(season_number.to_i, season_capitles_and_video_links)
    end    
    #puts "Serie page loaded for #{@serie[:title]} "
    @links
  end
  
  def init
    puts "New job for '#{self}' initializing"
    @html = Hpricot(open(@serie[:url], "User-Agent" => @@user_agent )) 
    puts "LinkGrabber job for '#{self}' got the page, now parsing..."
    
  end
  
  def to_s
    "LinkGrabber #{@serie[:title]}, episode: #{@season ? season.to_s+','+capitle.to_s : 'ALL'}"
  end
  
  private 
  def get_capitle_video_links(capitle)
    puts "Let's steal from #{capitle[:url]}"
    capitle_html = Hpricot(open(capitle[:url], "User-Agent" => @@user_agent )) 
    sleep(1)
    online_visualizations = []
    download_visualizations = []
    capitle_html./"div.post table tr td a" do |video_row| #/
      url = video_row.attributes['href']
      if url=~ /seriesyonkis.com\/go\/mv/
	#se podría coger el idioma y los subs...
	online_visualizations << url
      else 
	download_visualizations << url
      end
    end
    videos=[]
    online_visualizations.each do |online_url|
      videos<< get_visualization_for_url(online_url, :online)
    end
    download_visualizations.each do |download_url|
      videos<< get_visualization_for_url(download_url, :download)
    end
    puts "Stolen! :) #{videos.count}"
    videos
  end
  
  def get_visualization_for_url(url, visualization_type)
    #sleep(1)
    #visualization_html = Hpricot(open(url, "User-Agent" => @@user_agent )) 
    #puts "Lets get #{visualization_type} video from #{url};\n #{visualization_html.html}"
    
    #if (visualization_type == :online)
    #  visualization_html./"body  span  b  a" do |video_link| #/
    #puts "Found!! #{video_link}"
	
     # end
    #else
     # visualization_html./"body > span > b > a" do |video_link| #/
#	puts "Found!! #{video_link}"
 #    end
  #  end
    {:visualization_type => visualization_type, :url => url}
  end
  
  def persist_season_data(season, season_capitles_and_video_links)
    puts "Persisting data for season #{season}: #{season_capitles_and_video_links.count}"
    @@mutex.synchronize do
      CSV.open("sy-export.csv", "a", {:col_sep => ';', :force_quotes => true}) do |f|
	season_capitles_and_video_links.each do |capitle|
	  capitle[:videos].each do |video|
	    puts "Persisting video: #{video.inspect}"
	    f << [@serie[:title], season, capitle[:order], capitle[:title], video[:visualization_type].to_s, video[:url]]
	  end
	end
      end
    end
  end
    
  def get_seasons_to_download
    @seasons_to_get = []
    if (@season == nil )
      @seasons_to_get = get_all_season_numbers
    else
      @seasons_to_get << @season
    end    
  end
  
  def get_all_season_numbers
    seasons = []
    @html./("li._page_item h4 a").each do |season_link| #/
      season = season_link.inner_html.match /emporada (\d+) /
      season_number = $1 || 0;
      seasons << season_number
      puts "#{@serie[:title]} season found: #{season_number}"
    end
    seasons
  end
  
  def get_capitle_links_for_season(season_number)
    capitles = []
    season_number = season_number.to_i
    puts "Getting capitles links for #{@serie[:title]} season #{season_number}"
    season_block_number = season_number == 0 ? 0 : (season_number)
    #@html./("div#tempycaps ul ul:nth(#{season_block_number}) li a").each do |season_capitles_container|  #/
    @html./("div#tempycaps ul:nth(#{season_block_number}) li a").each do |season_capitles_container|  #/
      #puts "something found! #{season_capitles_container.inspect}" 
      capitle, href = [season_capitles_container.attributes['title'], season_capitles_container.attributes['href']]
      next if href=~ /temporada/ 
      season_capitles_container.inner_html.match /(\d+)x(\d+)/
      season_number, capitle_order = [$1,$2]
      puts "Found capitle : #{@serie[:title]}, capitle #{season_number}x#{capitle_order}: #{capitle} [#{href}]"
      capitles << {
	:serie_name => @serie[:title], 
	:season => season_number,
	:capitle => capitle,
	:order => capitle_order,
	:url => href}
    end
    puts "Finished getting #{@serie[:title]}'s capitles for season #{season_number}: \n \t#{capitles.count}"
    return capitles
  end
  
  def persist_data(capitles)
    
  end
end



class Producer
 def initialize(queue, series_and_urls_table)
    numthreads = 1
    puts "#{numthreads} Producer(s) created"
    producer_thread = Thread.new(queue) do |q|
      series_and_urls_table.each do |title, url|
	puts "Producer: New job adding for #{title}"
	q << SerieCapitlesVideoLinksGrabber.new({:title => title, :url => url}, nil, nil)   
      end
    end
    numthreads.times do
      queue << :end_of_producer
    end
  end
end

class Consumer 
  def initialize(queue)
    numthreads = 5
    @consumerthreads = []
  
    
    numthreads.times do |n|
      @consumerthreads << Thread.new(queue) do |q|
	puts "#{n+1} Consumer(s) created"
	until (link_grabber = q.pop) === :end_of_producer
	    data = link_grabber.do_job
	    puts "Job finished for #{link_grabber}"
	end
	   
      end
    end
  rescue 
   puts "Error: " + $!

  end
  
  def active_threads
    @consumerthreads
  end
end

html = open("http://www.seriesyonkis.com",
     "User-Agent" => "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/534.36 (KHTML, like Gecko) Chrome/13.0.766.0 Safari/534.36" ) 

doc = Hpricot(html)

@series_and_urls_table = {}

doc./("div.leftmenugroup li.page_item_ a").each_with_index do |serie_link,n| #/
    serie_name, url = [serie_link.attributes['title'], serie_link.attributes['href']]
    puts "Error with link #{serie_link.inspect}" and next unless serie_name and url
    puts "It #{n}: #{serie_name.inspect } -> #{url.inspect}" 
    @series_and_urls_table[serie_name]= url
end

puts "Created all series table, items: #{@series_and_urls_table.keys.count}"

Thread.abort_on_exception= true
queue = SizedQueue.new(5)
producer = Producer.new(queue, @series_and_urls_table)
consumer = Consumer.new(queue)

sleep 100000000

