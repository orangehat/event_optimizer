class FavoriteUser < ActiveRecord::Base
  attr_accessible :fb_id, :fb_name, :name, :tw_id, :tw_name
end
