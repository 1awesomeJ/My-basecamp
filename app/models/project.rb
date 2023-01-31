class Project < ApplicationRecord
    has_many_attached :uploads, dependent: :destroy
    belongs_to :user
end
