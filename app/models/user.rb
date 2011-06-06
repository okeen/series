class User < ActiveRecord::Base
 # acts_as_authentic do |c|
      #c.my_config_option = my_value # for available options see documentation in: Authlogic::ActsAsAuthentic
  #    c.validate_password_field = false
 # end # block optional

  class<<self
    def with_facebook_uid(uid)
      where(:facebook_id => uid).first
    end

    def titled(title)
      where("LOWER(series.title) = ?","#{title.downcase}")
    end
  end
end
