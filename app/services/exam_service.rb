class ExamService
  class ExamNotFoundError < StandardError; end
  class StudentNotFoundError < StandardError; end
  class StudentAlreadyRegisteredError < StandardError; end
  class SubjectNotFoundError < StandardError; end
  class StudentNotEnrolledError < StandardError; end

  def self.create_exam(params)
    subject = Subject.find_by(id: params[:subject_id])
    raise SubjectNotFoundError, "Subject not found" if subject.nil?

    exam = Exam.new(subject: subject)
    if exam.save
      {success: true, exam: exam}
    else
      {success: false, exam: exam.errors.full_messages}
    end
  end

  def self.register_student(params)
    student = Student.find_by(id: params[:student_id])
    exam = Exam.find_by(id: params[:exam_id])

    raise StudentNotFoundError, "Student not found" if student.nil?
    raise ExamNotFoundError, "Exam not found" if exam.nil?
    raise StudentAlreadyRegisteredError, "Student is already registered for this exam" if exam.student.exists?(student_id)

    subject = exam.subject
    unless subject.students.exists?(id: student_id)
      raise StudentNotEnrolledError, "Student must enroll in a subject before exam"
    end
    exam.students << student
    {success: true, message: "Student registered for exam"}
  end
end