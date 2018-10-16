class Affiliation < ApplicationRecord
  belongs_to :affiliate, class_name: "User"
  belongs_to :investment, class_name: "Users::Investment", optional: true
  belongs_to :user
end
