#------update_Series.rb------
# Loads an ics calendar file containing tv shows airing as calendar events, creates
# a CSV file containing the capitles it needs to fetch, and fires a sy-link-rober 
# to fetch the urls for these capitles :)
$:.unshift File.join(File.dirname(__FILE__),'lib')

#encoding: utf-8
require 'icalendar'
require 'date'
require 'activerecord'

class CalendarSeriesExtractor
  
  @calendar = nil
  
  def initialize(file)
    raise "File #{file} not found, exiting" and exit unless File.exists? file
    @ics_file_name = file
  end
  
  def todays_capitles
    load_calendar unless @calendar
    @calendar.events.collect do |event|
      airing_date = event.dtstart
      #only shows airing today
      next unless airing_date.to_date == Date.today
      
      event.summary.match /(.*) (\d+)x(\d+) - (.+)/
      serie,season,capitle,title = [$1,$2,$3,$4]
      description = event.description
      
      #puts "\t Found #{serie}, #{season}x#{capitle}: #{title}\n\t '#{description}'"
      {
	:serie => serie,
	:season => season,
	:capitle => capitle,
	:title => title,
	:description => description
      }
    end
  end
  
  private 
  
  def load_calendar
    @ics_file = File.new(@ics_file_name, "r")
    @calendar = Icalendar.parse(@ics_file)
    puts "Calendar file #{@ics_file.inspect} with #{@calendar.count} loaded OK" 
    @calendar = @calendar.first
  end
end

CalendarSeriesExtractor

def establish_connection
  ActiveRecord::Base.establish_connection(
    {
      :adapter  => 'sqlite3',
      :pool =>  5,
      :timeout => 5000,
      :database => 'db/production.sqlite3'  
    })
    
end

def persist_capitle(capitle)
  
end

CALENDAR_ICS_FILE = "db/current_week.ics"
calendar_episode_extractor = CalendarSeriesExtractor.new(CALENDAR_ICS_FILE)

todays_new_capitles = calendar_episode_extractor.todays_capitles
puts "Found #{todays_new_capitles.count} new capitles:"

todays_new_capitles.each do |capitle|
  puts "\n==========================================================="
  puts "\tNew capitle: #{capitle.inspect}"
  puts "==========================================================="
  persist_capitle(capitle)
  #capitle_videos = fetch_sy_videos_for_capitle(capitle)
#   puts "\tVideos:"
#   capitle_videos.each do |video|
#     #video_info = "\t\t#{video}   -> "
#     persist_video(video)
#     puts video_info + "persisted OK"
#   end
  puts Capitle.inspect
end