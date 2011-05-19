('a' .. 'z').to_a.each do |letter|
  rand(20).times do |n|
    Serie.create(
      :title => "#{letter}:#{n+1} title",
      :description => "#{letter}:#{n+1} description"
    )
  end
end
serie = Serie.first
5.times do |season|
  (10+rand(10)).times do |capitle_num|
    serie.capitles << Capitle.new(:title => "C#{season}_#{capitle_num}", :season => season, :order => capitle_num)
  end
end

