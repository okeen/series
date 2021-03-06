class Serie < ActiveRecord::Base

  has_many :capitles
  
  validates :title , :presence => true, :uniqueness => true

  before_create :remove_non_utf8_chars

  #will_paginate config
  cattr_reader :per_page
  @@per_page = 12

  #parameterized named scopes
  class<<self
    def with_letter(letter)
      where("LOWER(series.title) like ?","#{letter.downcase}%")
    end

    def titled(title)
      where("LOWER(series.title) = ?","#{title.downcase}")
    end
  end

  # route generations by title
  def to_param
    title
  end

  private
  def remove_non_utf8_chars
    title= attributes[:title].unpack("U*").pack("U*") unless attributes[:title].blank?
  end
end
