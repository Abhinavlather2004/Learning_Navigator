class Exam < ApplicationRecord
  belongs_to :subject
  has_and_belongs_to_many :students

  def subject_name
    subject.name
  end
end
