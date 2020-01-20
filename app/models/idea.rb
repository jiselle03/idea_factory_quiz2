class Idea < ApplicationRecord
    validates :title, presence: true, uniqueness: { case_sensitive: false }
    validates :description, presence: true
end
