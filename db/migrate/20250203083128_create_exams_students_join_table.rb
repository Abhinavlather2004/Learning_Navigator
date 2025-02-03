class CreateExamsStudentsJoinTable < ActiveRecord::Migration[8.0]
  def change
    create_table :exams_students, id: false do |t|
      t.references :exam, null: false, foreign_key: true
      t.references :student, null: false, foreign_key: true
    end
  end
end
