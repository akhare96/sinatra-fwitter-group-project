class User < ActiveRecord::Base
  has_many :tweets
  validates_presence_of :username, :email, :password
  has_secure_password

  def slug
    self.username.downcase.gsub(" ", "-")
  end

  def self.find_by_slug(slugged)
    User.all.find {|user| user.slug == slugged}
  end

end
