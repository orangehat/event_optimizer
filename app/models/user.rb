class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :trackable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :name, :provider, :uid, :token, :token_secret

  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    #unless user
    #  user = User.create(:name => auth.extra.raw_info.name,
    #                     :provider => auth.provider,
    #                     :uid => auth.uid,
    #                     :email => auth.info.email,
    #                     :password => Devise.friendly_token[0,20],
    #                     :token => auth.credentials.token
    #  )
    #end
    #user
  end

  def self.create_for_facebook_oauth(auth)
    user = User.create(:name => auth.extra.raw_info.name,
                       :provider => auth.provider,
                       :uid => auth.uid,
                       :email => auth.info.email,
                       :password => Devise.friendly_token[0,20],
                       :token => auth.credentials.token
    )
    user
  end

  def self.find_for_twitter_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
  end

  def self.create_for_twitter_oauth(auth)
    user = User.create(:name => auth.info.nickname,
                       :provider => auth.provider,
                       :uid => auth.uid,
                       :password => Devise.friendly_token[0,20],
                       :token => auth.credentials.token,
                       :token_secret => auth.credentials.secret
    )
    user
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end
end
