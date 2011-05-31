require 'icalendar'
require 'date'

class CalendarSeriesExtractor
  
  @calendar = nil
  
  def initialize(file)
    raise "File #{file} not found, exiting" and exit unless File.exists? file
    @ics_file_name = file
  end
  
  def day_capitles(day)
    load_calendar unless @calendar
    todays_capitles = @calendar.events.select {|e| e.dtstart.to_date == day}
    todays_capitles.collect do |event|
      #airing_date = event.dtstart
      #only shows airing today
      #next unless airing_date.to_date == Date.today
      puts "++"
      event.summary.match /(.*) (\d+)x(\d+) - (.+)/
      serie,season,capitle,title = [$1,$2,$3,$4]
      description = event.description
      
      #puts "\t Found #{serie}, #{season}x#{capitle}: #{title}\n\t '#{description}'"
      {
	:serie => serie,
	:season => season,
	:order => capitle,
	:title => title,
	:description => description,
	:airing_date => event.dtstart
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
