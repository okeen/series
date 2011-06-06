class UserSession < ActiveRecord::Base
#class UserSession < Authlogic::Session::BaseActiveRecord::Base
    # configuration here, see documentation for sub modules of Authlogic::Session
 belongs_to :user
  end