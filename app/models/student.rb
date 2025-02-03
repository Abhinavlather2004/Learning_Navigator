class Student < ApplicationRecord

  # has_many :exams, dependent: :destroy
  # has_and_belongs_to_many :exams
  has_and_belongs_to_many :subjects
  validates :registration_id, presence: true, uniqueness: true
  validates :name, presence: true

end


