class Video < ActiveRecord::Base
  belongs_to :capitle

  validates :visualization_type,
    :presence => true,
    :format => {:with => /download|video/}

  validates :url,
    :presence => true,
    :uniqueness => true

  class << self
    def online
      where(:visualization_type => 'online')
    end

    def downloads
      where(:visualization_type => 'download')
    end

  end
end
