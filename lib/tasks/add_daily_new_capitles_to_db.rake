#encoding: utf-8

task :add_daily_new_capitles_to_db => :environment do
  #------update_Series.rb------
  # Loads an ics calendar file containing tv shows airing as calendar events, creates
  # a CSV file containing the capitles it needs to fetch, and fires a sy-link-rober
  # to fetch the urls for these capitles :)
  require 'calendar_series_extractor'
  require 'yonki_robe'

  @@mutex = Mutex.new
  
  def persist_capitles(capitles)
    puts ">>>>>>>>>>>>>>>> #{capitles}"
    capitles.each do |capitle|
      serie = Serie.titled(capitle[:serie]).first
      if serie.blank?
        puts "Not found serie #{capitle[:serie]}"
        return
      end
      puts "Found existing serie #{serie.title}"
      existing_capitle = serie.capitles.season_capitle(capitle[:season], capitle[:order])

      unless existing_capitle.blank?
        puts "Capitle already exists, skipping..."
        return
      end
      puts "Capitle not found, creating new..."
      new_capitle = serie.capitles.create(
        :season => capitle[:season],
        :order =>  capitle[:order],
        :title => capitle[:title],
        :plot => capitle[:description],
        :airing_date => capitle[:airing_date])
      puts "Created new capitle, adding videos #{capitle[:videos].inspect}... "
      capitle[:videos].each do |capitle_video|
        new_capitle.videos.create(capitle_video)
      end

    end
      
  end

  def steal_capitles_links(capitles)
    @series_and_urls_table = []
    serie_names_downcase = capitles.collect { |c| c[:serie].downcase }
    puts "Looking for series : #{serie_names_downcase.inspect}"
    html = open("http://www.seriesyonkis.com",
      "User-Agent" => "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/534.36 (KHTML, like Gecko) Chrome/13.0.766.0 Safari/534.36" )

    doc = Hpricot(html)
    doc./("div.leftmenugroup li.page_item_ a").each_with_index do |serie_link,n| #/
      serie_name, url = [serie_link.attributes['title'], serie_link.attributes['href']]

      puts "Error with link #{serie_link}" and next unless serie_name and url
      unless (serie_names_downcase.include? serie_name.downcase)
        #puts "Not Found / intereested in #{serie_name}"
        next
      end
      puts "Found match #{n}: #{serie_name.inspect } -> #{url.inspect}"
      capitle = capitles.select {|c| c[:serie].downcase == serie_name.downcase}.first
      @series_and_urls_table << {:serie=> serie_name,  :url => url, :capitle => capitle[:order], :season => capitle[:season]}
    end

    puts "Created all series table, items: #{@series_and_urls_table.count}\nFetching items from Series Yonkis..."

    Thread.abort_on_exception= true
    queue = SizedQueue.new(5)
    producer = YonkiRobe::Producer.new(queue, @series_and_urls_table)
    # create the producer passing a block that merges existing the existing capitle
    # data with the videos links got by the LinkGrabber and persist them
    consumer = YonkiRobe::Consumer.new(queue) do |capitles_with_videos|
      capitles_with_videos.each do |capitle|
        next if capitle.blank?
        calendar_capitle =  capitles.select {|c| c[:serie].downcase == capitle[:serie].downcase}.first
        capitle.merge!(calendar_capitle)
      end
      persist_capitles(capitles_with_videos)
      
    end
    sleep 100000000
  end

  
  CALENDAR_ICS_FILE = "db/current_week.ics"
  calendar_episode_extractor = CalendarSeriesExtractor.new(CALENDAR_ICS_FILE)

  todays_new_capitles = calendar_episode_extractor.day_capitles(Date.parse("25/5/2011"))
  puts "Found #{todays_new_capitles.count} new capitles:"

  todays_new_capitles.each do |capitle|
    puts "\n==========================================================="
    puts "\tNew capitle: #{capitle.inspect}"
    puts "==========================================================="
    #persist_capitle(capitle)
    #capitle_videos = fetch_sy_videos_for_capitle(capitle)
    #   puts "\tVideos:"
    #   capitle_videos.each do |video|
    #     #video_info = "\t\t#{video}   -> "
    #     persist_video(video)
    #     puts video_info + "persisted OK"
    #   end
    #puts Capitle.inspect
  end

  steal_capitles_links(todays_new_capitles)
  
end
