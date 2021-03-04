class Like < ApplicationRecord
  belongs_to :idea
  belongs_to :user

  validates(
    :idea_id, 
    uniqueness: {
      scope: :user_id,
      message: "You have already liked this."
    }
  )
end
