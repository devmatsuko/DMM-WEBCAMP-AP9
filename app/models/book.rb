class Book < ApplicationRecord
	belongs_to :user
	has_many :favorites, dependent: :destroy
	has_many :book_comments, dependent: :destroy

	validates :title, presence: true
	validates :body, presence: true, length: {maximum: 200}

	# いいねをしているかを判定する
	def favorited_by?(user)
	    favorites.where(user_id: user.id).exists?
	end
	
	# Bookを検索し、結果を返す
	def self.search_for(content, how)
	    if how == 'perfect'
	    	Book.where(title: content)
	    elsif how == 'forward'
	    	Book.where('title LIKE ?', content+'%')
	    elsif how == 'backward'
	    	Book.where('title LIKE ?', '%'+content)
	    else
	    	Book.where('title LIKE ?', '%'+content+'%')
	    end
    end
end
