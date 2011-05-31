#encoding: utf-8

task :fetch_all_sy_videos => :environment do
  require 'open-uri'
  require 'hpricot'
  require 'thread'
  require 'yonki_robe'

  html = open("http://www.seriesyonkis.com",
      "User-Agent" => "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/534.36 (KHTML, like Gecko) Chrome/13.0.766.0 Safari/534.36" ) 

  doc = Hpricot(html)

  @series_and_urls_table = []

  doc./("div.leftmenugroup li.page_item_ a").each_with_index do |serie_link,n| #/
      serie_name, url = [serie_link.attributes['title'], serie_link.attributes['href']]
      
      puts "Error with link #{serie_link}" and next unless serie_name and url
      if (serie_name.downcase < "the of")
	puts "Not intereested in #{serie_name}"
	next
      end
      if (serie_name[0] == "Á")
	puts "Not intereested in #{serie_name}"
	next
      end
      if (serie_name[0] == "¿")
	puts "Not intereested in #{serie_name}"
	next
      end
      if (serie_name[0] == "¡")
	puts "Not intereested in #{serie_name}"
	next
      end
      puts "It #{n}: #{serie_name.inspect } -> #{url.inspect}" 
      @series_and_urls_table << {:serie=> serie_name,  :url => url }
      
  end

  puts "Created all series table, items: #{@series_and_urls_table.count}"

  Thread.abort_on_exception= true
  queue = SizedQueue.new(5)
  producer = YonkiRobe::Producer.new(queue, @series_and_urls_table)
  consumer = YonkiRobe::Consumer.new(queue, 9) do |capitles_data|
    puts "Workeeddddddddddd!!!!!!!!!!"
  end

  sleep 100000000
end