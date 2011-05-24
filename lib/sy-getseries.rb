#Filename: sy-getseries.rb
#Developed: january 2010
#Function: Download "friendly" information from seriesyonkis.com. The whole database.

require 'net/http';

#Command parameters
#	[opcional] series, seasons, episodes or links parameters allows you to refresh just
#		some of the db files.
#	For exemple:
#		ruby sy-getseries.rb series seasons
#		... doesn't updates episodes and links.
$refreshseries = (ARGV.index("series") != nil)
$refreshseasons = (ARGV.index("seasons") != nil)
$refreshepisodes = (ARGV.index("episodes") != nil)
$refreshlinks = (ARGV.index("links") != nil)

#If you don't specify any option, you'll refresh everything
if not $refreshseries and not $refreshseasons and not $refreshepisodes and not $refreshlinks then
	$refreshseries, $refreshseasons, $refreshepisodes, $refreshlinks = true, true, true, true
end

#Paths to temporary files
$tmpscript = "tmp/tmpscript.js"
$tmpresult = "tmp/tmpresult.txt"

#Declare some constants
$seriesfilename = "sy-series.txt"
$seasonsfilename = "sy-seasons.txt"
$episodesfilename = "sy-episodes.txt"
$linksfilename = "sy-links.txt"

#Update series file
#	Reads the root of seriesyonkis.com finding out the series.
#	Writes the ID and title of all the series in $seriesfilename.
#	Prints info about every serie that wasn't in $seriesfilename,
#		(useful for logging and for giving information to
#		the user about the process).
def updateseries()
	#Get the index content
	content = gethttpcontent("http://www.seriesyonkis.com/")

	print "Looking for new series\n"

	#Find every occurence of a "page_item"
	series = ""
	content.scan(/<li class="page_item">(.*?)<\/li>/) {
		linkserie = $1

		#Extract the code (id) of the serie from its url
		if linkserie =~ /<a href="http:\/\/www.seriesyonkis.com\/serie\/(.*?)\/"/ then
			serie_id = $1

			#Extract the name of the serie
			if linkserie =~ /title="(.*?)"/ then
				serie_title = $1

				#Save the serie, if new
				line = serie_id + ";" + serie_title + "\n"

				if addlineinfileifnotinarray($seriesfilename, $seriesdb, line) then
					$seriesdb.insert($seriesdb.count - 1, line)
					print "	" + serie_title + "\n"
				end
			end
		end
	}

	print "Your serie's file is up to date\n"
end

#Update seasons file
#	Reads $seriesdb and calls getseasons for each serie.
def updateseasons()
	print "Looking for new seasons\n"

	#For each serie
	$seriesdb.to_s.scan(/(.*?);(.*?)\n/) {
		serie_id = $1
		serie_title = $2

		#Get the seasons
		getseasons(serie_id, serie_title)
	}

	print "Your season's file is up to date\n"
end

#Update episodes file
#	Reads seasonsfilename and calls getepisodes for each season.
def updateepisodes()
	print "Looking for new episodes\n"

	#For each season
	$seasonsdb.to_s.scan(/(.*?);(.*?);(.*?);(.*?)\n/) {
		serie_id = $1
		serie_title = $2
		season_id = $3
		season_title = $4

		#Get the episodes
		getepisodes(serie_id, season_id,
			serie_title, season_title)
	}

	print "Your episodes's file is up to date\n"
end

#Update links file
#	Reads episodesfilename and calls getepisodelinks for each episode
def updatelinks()
	print "Looking for new links\n"

	#For each episode
	$episodesdb.to_s.scan(/(.*?);(.*?);(.*?);(.*?);(.*?);(.*?);(.*?)\n/) {
		serie_id = $1
		serie_title = $2
		season_id = $3
		season_title = $4
		episode_id = $5
		episode_titid = $6
		episode_title = $7
		
		#Get the links
		getepisodelinks(serie_id, season_id,
			episode_id, episode_titid, serie_title,
			season_title, episode_title)
	}

	print "Your links's file is up to date\n"
end

#Get the seasons of a serie
#	Reads the page of a serie.
#	Updates the seasons of the serie in seasonsfilename.
def getseasons(serie_id, serie_title)
	content = gethttpcontent("http://www.seriesyonkis.com/serie/" + serie_id + "/")

	#Print "looking for new seasons..."
	print "	" + serie_title + "\n"

	#Find every occurence of <h4>
	content.scan(/<h4>(.*?)<\/h4>/) {
		linkseason = $1

		#Extract the id of the season
		if linkseason =~ /<a href="http:\/\/www.seriesyonkis.com\/temporada\/#{serie_id}\/(.*?)\/"/ then
			season_id = $1

			#Extract the name of the season
			if linkseason =~ /title="(.*?)"/ then
				season_title = $1

				#Save the results
				line = serie_id + ";" + serie_title + ";" +
					season_id + ";" + season_title + "\n"

				if addlineinfileifnotinarray($seasonsfilename, $seasonsdb, line) then
					$seasonsdb.insert($seasonsdb.count - 1, line)
					print "		" + season_title + "\n"
				end
			end
		end
	}
end

#Get the episodes of a serie
#	Reads one season page of a serie.
#	Update the episodes of this season in episodesfilename.
def getepisodes(serie_id, season_id, serie_title, season_title)
	content = gethttpcontent("http://www.seriesyonkis.com/temporada/" +
		serie_id + "/" + season_id + "/")

	#Print "looking for new episodes..."
	print "	" + serie_title + " / " + season_title + "\n"

	#Find every occurence of <h5>
	content.scan(/<h5>(.*?)<\/h5>/) {
		linkepisode = $1

		#Extract the id of the episode
		if linkepisode =~ /<a href="http:\/\/www.seriesyonkis.com\/capitulo\/#{serie_id}\/(.*?)\/(.*?)\/"/ then
			episode_titid = $1
			episode_id = $2

			#Extract the name of the episode
			if linkepisode =~ /title="(.*?)"/ then
				episode_title = $1

				#Save the results
				line = serie_id + ";" + serie_title + ";" +
					season_id + ";" + season_title + ";" +
					episode_id + ";" + episode_titid + ";" +
					episode_title + "\n"

				if addlineinfileifnotinarray($episodesfilename, $episodesdb, line) then
					$episodesdb.insert($episodesdb.count - 1, line)
					print "		" + episode_title + "\n"
				end
			end
		end
	}
end

#Get the links of an episode
#	Reads the page of one episode.
#	Updates the links of the episode if linksfilename.
#	To make it faster...
#		it verifies that the link doesn't exists (linkimported) yet
#		before trying to "decode" (getdirectlink) it.
def getepisodelinks(serie_id, season_id, episode_id,
	episode_titid, serie_title, season_title, episode_title)

	content = gethttpcontent("http://www.seriesyonkis.com/capitulo/" +
		serie_id + "/" + episode_titid + "/" + episode_id + "/")

	#Print "looking for new links..."
	print "	" + serie_title + " / " + season_title + " / " + episode_title + "\n"

	#Find every link to a player/visor
	content.scan(/href="http:\/\/www.seriesyonkis.com\/player\/(.*?)"/) {
		linknodirect = $1

		#Get the direct link
		if not linkimported(serie_id, season_id, episode_id, episode_titid,
			serie_title, season_title, episode_title, linknodirect) then

			#Tryies to get the "decoded" version of the link
			linkdirect = getdirectlink(linknodirect).to_s

			#Save the results
			line = serie_id + ";" + serie_title + ";" +
				season_id + ";" + season_title + ";" +
				episode_id + ";" + episode_titid + ";" +
				episode_title + ";" + linkdirect + ";" +
				linknodirect + "\n"

			if addlineinfileifnotinarray($linksfilename, $linksdb, line) then
				$linksdb.insert($linksdb.count - 1, line)
				print "		" + linkdirect + "\n"
			end
		end
	}
end

#Get the direct link to the visor
#	Decode a link calling to the original seriesyonki's JavaScript function.
#	If I didn't it before, I download the corresponding .js file.
def getdirectlink(linknodirect)
	content = gethttpcontent("http://www.seriesyonkis.com/player/" + linknodirect)

	#Get the script name
	if content =~ /<script type="text\/javascript" src="(.*?).js"><\/script>/ then
		scriptname = $1 + ".js"
		linkjs = "http://www.seriesyonkis.com/player/" + scriptname

		#Download the js script, if I didn't before
		if not File.exists?("js/" + scriptname) then
			File.open("js/" + scriptname, "w") do |fs|
				fs.puts gethttpcontent(linkjs)
				fs.close
			end
		end

		#Get the location.search
		if linknodirect =~ /(.*?)\?/ then
			locationsearch = linknodirect.gsub($1, "")
		end

		#Delete temporary files, if they already exist
		delfileifexists($tmpscript)
		delfileifexists($tmpresult)

		#Creates a local .js a little bit modified for run it with SpiderMonkey
		createtmpscript(scriptname, $tmpscript, locationsearch)
		system("js " + $tmpscript + " > " + $tmpresult)

		contentlink = IO.readlines($tmpresult).to_s
		if contentlink =~ /<a onmouseover="window.status=''; return true;" onmouseout="window.status=''; return true;" href='(.*?)'>/
			return $1
		else
			if contentlink =~ /<b><a onmouseover="window.status=''; return true;" onmouseout="window.status=''; return true;" target='_blank' href="(.*?)">/
				return $1
			end

			#I write a "NotFound" string, to make possible to locate the
			#	errors after the process is finished.
			return "NotFound"
		end

		#Delete temporary files
		delfileifexists($tmpscript)
		delfileifexists($tmpresult)
	end
end

#Erases temporary files
def deletetemporaryfiles()
	#Delete previous temporary files
	if File.exists?($tmpresult) then
		system("rm " + $tmpresult)
	end

	if File.exists?($tmpscript) then
		system("rm " + $tmpscript)
	end
end

#Erases existing data files
def deleteexistingfiles()
	#Delete previous temporary files
	deletetemporaryfiles()

	#Delete the series file
	delfileifexists($seriesfilename)

	#Delete the seasons file
	delfileifexists($seasonsfilename)

	#Delete the episodes file
	delfileifexists($episodesfilename)

	#Delete the links file
	delfileifexists($linksfilename)
end

#Creates needed folders (if they don't exist)
def createbasefolders
	if not folderexists("tmp") then
		system("mkdir tmp")
	end

	if not folderexists("js") then
		system("mkdir js")
	end
end

#Returns true if a folder exists, false otherwise
def folderexists(path)
	return (Dir[path] != [])
end

#Delete a file if exists
def delfileifexists(filename)
	if File.exists?(filename) then
		File.delete(filename)
	end
end

#Add a line to a file if it didn't already exists in the local db
def addlineinfileifnotinarray(filename, dbarray, line)
	#Verify that the line exists
	if not lineinarray(dbarray, line) or dbarray == nil then
		#Append the line to the file
		File.open(filename, "a") do |fs|
			fs.puts line
			fs.close
		end

		#It only returns true if it didn't exists, but it exists now
		return true
	else
		return false
	end
end

#Add a line to a file if it didn't already exists if a file
def addlineonlyifnew(filename, line)
	#Verify if the line exists
	if not lineexists(filename, line) then
		#Append the line to the file
		File.open(filename, "a") do |fs|
			fs.puts line
			fs.close
		end

		return true
	else
		return false
	end
end

#Create a temporary JavaScript to decode a link
def createtmpscript(scriptname, tmpscript, locationsearch)
	File.open(tmpscript, "w") do |fs|
		#I define my own 'location' and 'document' objects
		#	to be able to redefine local.search and
		#	document.write expressions.
		fs.puts "function locclass() {
				this.search = '" + locationsearch + "';
			}

			location = new locclass();

			function docclass() {
				this.write = docwrite;
			}

			function docwrite(str) {
				print(str);
			}

			document = new docclass(); \n"
		fs.puts IO.readlines("js/" + scriptname,'').to_s + "\n"
		fs.puts "sy1();"
		fs.close
	end
end

#Get genericaly, HTTP content
#	Receives a URL and returns its content
def gethttpcontent(url)
	begin
		url = URI.parse(url)

		#Perform the HTTP query and get the content
		req = Net::HTTP::Get.new(url.path);
		res = Net::HTTP.start(url.host, url.port) { |http|
			http.request(req); }

		#Return the body
		return res.body;
	rescue
		return ""
	end
end

#Verify if the links of an episode have already been imported
def linkimported(serie_id, season_id, episode_id,
	episode_titid, serie_title, season_title, episode_title, linknodirect)

	return ($linksdb.to_s =~ /#{serie_id};#{serie_title};#{season_id};#{season_title};#{episode_id};#{episode_titid};(.*?);#{linknodirect}\n/)
end

#Verify if a line exists in an array
def lineinarray(dbarray, line)
	return (dbarray.index(line) != nil)
end

#Verify if a line exists in a file
def lineexists(filename, line)
	if File.exists?(filename) then
		#If the file exists, I find the line
		IO.readlines(filename).each { |fileline|
			if fileline.chomp == line.chomp then
				return true
			end
		}

		return false
	else
		#If file doesn't exist, return false
		return false
	end	
end

#Reads a text file
def readfileifexists(filename)
	if File.exists?(filename) then
		return IO.readlines(filename)
	else
		return Array.new
	end
end

#Delete existing database files
#deleteexistingfiles(seriesfilename, seasonsfilename, episodesfilename, linksfilename)

#Create base folders (tmp and js)
createbasefolders()

#Erase previous temporary files
deletetemporaryfiles()

#Read existing database files if they exists
$seriesdb = readfileifexists($seriesfilename)
$seasonsdb = readfileifexists($seasonsfilename)
$episodesdb = readfileifexists($episodesfilename)
$linksdb = readfileifexists($linksfilename)

#Update series file
if $refreshseries then
	updateseries()
end

#Update seasons file (looks for new seasons for each serie in seriesfilename)
if $refreshseasons then
	updateseasons()
end

#Update episodes file (looks for new episodes for each season in seasonsfilename)
if $refreshepisodes then
	updateepisodes()
end

#Update links file (looks for new links for each season in linksfilename)
if $refreshlinks then
	updatelinks()
end

#Erase temporary files
deletetemporaryfiles()

print "Finished! \n"
