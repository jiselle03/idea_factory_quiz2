class Idea < ApplicationRecord
    belongs_to :user
    has_many :reviews, dependent: :destroy
    has_many :likes, dependent: :destroy
    has_many :likers, through: :likes, source: :user
    
    validates :title, presence: true, uniqueness: { case_sensitive: false }
    validates :description, presence: true
end
