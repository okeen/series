require 'serie_capitles_video_links_grabber'
require 'thread'

module YonkiRobe
  
  class Producer
    def initialize(queue, series_and_urls_table)
      numthreads = 1
      puts "#{numthreads} Producer(s) created"
      producer_thread = Thread.new(queue) do |q|
        series_and_urls_table.each do |download_data|
          puts "Producer: New job adding for #{download_data.inspect}"
          q << SerieCapitlesVideoLinksGrabber.new(download_data)
        end
      end
      numthreads.times do
        queue << :end_of_producer
      end
    end
  end

  class Consumer
    def initialize(queue, numthreads = 2)
      @consumerthreads = []
  
      numthreads.times do |n|
        @consumerthreads << Thread.new(queue) do |q|
          puts "Consumer#{n}  created"
          until (link_grabber = q.pop) === :end_of_producer
            data = link_grabber.do_job
            puts "Consumer Job finished for #{link_grabber}, results: #{data}"
            yield(data)
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

end