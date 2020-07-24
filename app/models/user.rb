class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true
  validates :name,  length: { maximum: 20 }
  validates :name, length: { minimum: 2 } 
  validates :introduction,  length: { maximum: 50 }

  attachment :profile_image

  has_many :books, dependent: :destroy
  has_many :favorites, dependent: :destroy

  has_many :follower, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :followed, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy

  has_many :follows, through: :follower, source: :followed
  has_many :followers, through: :followed, source: :follower

  def follow(user_id)
    follower.create(followed_id: user_id)
  end

    # ユーザーのフォローを外す
  def unfollow(user_id)
    follower.find_by(followed_id: user_id).destroy
  end

  # フォローしていればtrueを返す
  def following?(user)
    follows.include?(user)
  end
end
