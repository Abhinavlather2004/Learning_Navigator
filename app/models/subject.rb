class Subject < ApplicationRecord
  # has_many :exams
  # has_many :students, through: :exams  
  has_and_belongs_to_many :students
  validates :name, presence: true, uniqueness: true
end
