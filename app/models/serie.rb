class Serie < ActiveRecord::Base

  validates :title , :presence => true, :uniqueness => true

  #will_paginate config
  cattr_reader :per_page
  @@per_page = 12

  #parameterized named scopes
  class<<self
    def with_letter(letter)
      where("LOWER(series.title) like ?","#{letter}%")
    end
  end

end
