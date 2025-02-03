class RemoveStudentIdFromExams < ActiveRecord::Migration[8.0]
  def change
    remove_column :exams, :student_id, :integer
  end
end
