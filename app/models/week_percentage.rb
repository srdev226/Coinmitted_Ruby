class WeekPercentage < ApplicationRecord
  attr_accessor :date
  validates :percentage, presence: true #, format: { with: /[+-]?([0-9]*[.])?[0-9]+/, message: "Integer or Float only. No sign allowed." }
  validates_numericality_of :percentage
  validates :date, presence: true
  validates_uniqueness_of :first_date
  validates_uniqueness_of :last_date
end
