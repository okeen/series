namespace :series do
  task :fill_db_with_videos do
    desc "Fill the DB with the data from the CSV db/video_data.csv"
    DATA_CSV_FILE = "db/video_data.csv"
    file DATA_CSV_FILE
    require 'csv'

    CSV.foreach DATA_CSV_FILE do |capitle_row|
      puts capitle_row
    end
  end
end