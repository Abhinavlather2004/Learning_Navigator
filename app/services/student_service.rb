class StudentService
  class StudentNotFoundError < StandardError; end

  def self.create_student(params)
    student = Student.new(params)
    if student.save
      { success: true, student: student }
    else
      { success: false, errors: student.errors.full_messages }
    end
  end
end
