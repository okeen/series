('a' .. 'z').to_a.each do |letter|
  20.times do |n|
    Serie.create(
      :title => "#{letter}:#{n} title",
      :description => "#{letter}:#{n} description"
    )
  end
end