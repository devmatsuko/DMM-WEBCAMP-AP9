class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :
  
  include JpPrefecture
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  
  # フォローする側のリレーションシップ
  has_many :active_relationships, class_name: "Relationship", foreign_key: :follower_id, dependent: :destroy
  # N：Nのリレーションシップにはthroughを使う。user.following = user.followed.idとなるようにsourceを設定
  has_many :following, through: :active_relationships, source: :followed

  # フォロワーのリレーションシップ
  has_many :passive_relationships, class_name: "Relationship", foreign_key: :followed_id
  # N：Nのリレーションシップにはthroughを使う。user.followers = user.follower.idとなるようにsourceを設定
  has_many :followers, through: :passive_relationships, source: :follower
  
  # 他パラメータ
  # 画像を設定できるようにする
  attachment :profile_image, destroy: false
  # 都道府県コードから都道府県名に自動で変換する
  jp_prefecture :prefecture_code
  
  #バリデーションチェック 
  validates :name,length: {maximum: 20, minimum: 2}, uniqueness: true
  validates :introduction, length: {maximum: 50}
  
  #メソッド 
  #すでにフォロー済みであればture返す
  def following?(other_user)
    following.include?(other_user)
  end
  
  # ユーザーをフォローする
  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end

  # ユーザーをフォロー解除する
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end
  
  # ユーザーを検索し、結果を返す
  def self.search_for(content, how)
    if how == 'perfect'
      User.where(name: content)
    elsif how == 'forward'
      User.where('name LIKE ?', content + '%')
    elsif how == 'backward'
      User.where('name LIKE ?', '%' + content)
    else
      User.where('name LIKE ?', '%' + content + '%')
    end
  end
  
  # @user.prefecture_nameで該当ユーザーの住所(都道府県)を表示出来るようにする
  def prefecture_name
    JpPrefecture::Prefecture.find(code: prefecture_code).try(:name)
  end
  
  def prefecture_name=(prefecture_name)
    self.prefecture_code = JpPrefecture::Prefecture.find(name: prefecture_name).code
  end
  
end
