class CreateStudents < ActiveRecord::Migration[8.0]
  def change
    create_table :students do |t|
      t.string :registration_id
      t.string :name

      t.timestamps
    end
  end
end
