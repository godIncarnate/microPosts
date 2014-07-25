class User < ActiveRecord::Base
  before_save { self.email = email.downcase }
  
  before_create :create_remember_token
  
  validates :name, presence: true, length: { maximum: 50 }
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validates :email, presence:   true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  
  has_secure_password
  
  validates :password, length: { minimum: 6 }
  
  has_many :microposts, dependent: :destroy
  
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  
  #关注的用户关系
  has_many :followed_users, through: :relationships, source: :followed
  
  has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name:  "Relationship",
                                   dependent:   :destroy
  #粉丝关系
  has_many :followers, through: :reverse_relationships, source: :follower
  
  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.hash(token)
    Digest::SHA1.hexdigest(token.to_s)
  end
  
  def feed
    # This is preliminary. See "Following users" for the full implementation.
    # Micropost.where("user_id = ?", id)
    
    #获取用户的微博和关注者的微博
    Micropost.from_users_followed_by(self)
  end


  #检查用户是否被关注
  def following?(other_user)
    relationships.find_by(followed_id: other_user.id)
  end

  # 关注用户
  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end
  #取消关注
  def unfollow!(other_user)
    relationships.find_by(followed_id: other_user.id).destroy
  end
  
  
  
  private

  def create_remember_token
    self.remember_token = User.hash(User.new_remember_token)
  end
  
  
  
end