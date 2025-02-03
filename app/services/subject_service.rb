class SubjectService
  class SubjectNotFoundError < StandardError; end
  class StudentNotFoundError < StandardError; end
  class StudentAlreadyEnrolledError < StandardError; end

  def self.create_subject(params)
    subject = Subject.new(params)
    if subject.save
      { success: true, subject: subject }
    else
      { success: false, errors: subject.errors.full_messages }
    end
  end

  def self.enroll_student(params)
    student = Student.find_by(id: params[:student_id])
    subject = Subject.find_by(id: params[:subject_id])

    raise StudentNotFoundError, "Student not found" if student.nil?
    raise SubjectNotFoundError, "Subject not found" if subject.nil?
    raise StudentAlreadyEnrolledError, "Student already enrolled in this subject" if subject.students.include?(student)

    subject.students << student
    { success: true, message: "Student successfully enrolled in the subject" }
  end
end
