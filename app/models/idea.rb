class Idea < ApplicationRecord
    belongs_to :user
    has_many :reviews
    
    validates :title, presence: true, uniqueness: { case_sensitive: false }
    validates :description, presence: true
end
