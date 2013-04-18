class HomeController < ApplicationController
  require 'koala'
  require 'pp'
  require 'open-uri'

  def index
  end

  def facebook
    @oauth = Koala::Facebook::OAuth.new '284921154963373', '5ef8e4119bb7d1242db29f19b69b73a8', user_omniauth_callback_url(:facebook)
    url = @oauth.url_for_oauth_code
    open url do |data|
      pp data.read
    end
    user = User.find current_user.id
    access_token = @oauth.exchange_access_token user.token
    pp access_token
  end

  private
  def parse_url(url)
    components = url.split("&").inject({}) do |hash, bit|
      key, value = bit.split("=")
      hash.merge!(key => value)
    end
    components
  end

end
