class Picture < ApplicationRecord
    belongs_to :user
    has_one_attached :file
    has_one_attached :preview
end
