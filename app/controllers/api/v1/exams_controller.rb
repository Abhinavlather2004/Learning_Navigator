class Api::V1::ExamsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :validate_student_enrollment, only: [:register]

  before_action :set_exam, only: [:exam_details, :update_exam, :delete_exam]


  def all_exams
    exams = Exam.includes(:subject)
    render json: exams, only: [:id, :subject_id, :created_at, :updated_at], methods: [:subject_name]
  end

  def exam_details
    render json: @exam, only: [:id, :subject_id, :created_at, :updated_at], methods: [:subject_name]
  end
  
  
  def register_exam
    begin
      result = ExamService.create_exam(exam_params)
      if result[:success]
        render json: {message: "Exam created successfully"}, status: :created
      else
        render json: {errors: result[:errors] }, status: :unprocessable_entity
      end
    rescue ExamService::SubjectNotFoundError => e
      render json: { error: e.message }, status: :not_found
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end
    # subject = Subject.find_by(id: exam_params[:subject_id])
  
    # if subject.nil?
    #   return render json: { error: "Subject not found" }, status: :not_found
    # end
  
    # # ✅ Create Exam without requiring a Student
    # exam = Exam.new(subject: subject)
  
    # if exam.save
    #   render json: { message: "Exam created successfully" }, status: :created
    # else
    #   Rails.logger.debug "Exam validation errors: #{exam.errors.full_messages}"
    #   render json: { errors: exam.errors.full_messages }, status: :unprocessable_entity
    # end
  end
  
  def  update_exam
    if @exam.update(exam_params)
      render json: @exam, status: :ok
    else
      render json: {errors: @exam.errors.full_messages}, status: :unprocessable_entity
    end
  end

  def delete_exam
    @exam.destroy
    head :no_content
  end

  def register
    begin
      result = ExamService.register_student(params)
      render json: { message: result[:message] }, status: :ok
    rescue ExamService::StudentNotFoundError, ExamService::ExamNotFoundError => e
      render json: { error: e.message }, status: :not_found
    rescue ExamService::StudentAlreadyRegisteredError => e
      render json: { error: e.message }, status: :unprocessable_entity
    rescue ExamService::StudentNotEnrolledError => e
      render json: { error: e.message }, status: :forbidden
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end

    # student = Student.find_by(id: params[:student_id])
    # exam = Exam.find_by(id: params[:exam_id])
  
    # if student.nil?
    #   return render json: { error: "Student not found" }, status: :not_found
    # end
  
    # if exam.nil?
    #   return render json: { error: "Exam not found" }, status: :not_found
    # end
  
    # if exam.students.exists?(student.id)
    #   return render json: { error: "Student already registered for this exam" }, status: :unprocessable_entity
    # end
  
    # # Register student for the exam
    # exam.students << student
    # render json: { message: "Student registered for the exam" }, status: :ok
  end
  

  private

  def exam_params
    params.require(:exam).permit(:subject_id)
  end

  def set_exam
    @exam = Exam.find_by(id: params[:id])
    render json: { error: "Exam not found" }, status: :not_found if @exam.nil?
  end
  

  # def validate_student_enrollment
  #   student = Student.find_by(id: params[:student_id])
  #   exam = Exam.find_by(id: params[:exam_id])

  #   if student.nil? || exam.nil?
  #     render json: { error: "Student or Exam not found" }, status: :not_found
  #     return
  #   end
  #   subject = exam.subject
  #   unless subject.students.exists?(id: student.id)  
  #     render json: { error: "Student must enroll in subject before exam" }, status: :forbidden
  #   end
  # end

end
