class Serie < ActiveRecord::Base

  validates :title , :presence => true, :uniqueness => true

  #will_paginate config
  cattr_reader :per_page
  @@per_page = 10

  #parameterized named scopes
  class<<self
    
  end

end
