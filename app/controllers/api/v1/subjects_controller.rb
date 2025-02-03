class Api::V1::SubjectsController < ApplicationController

  skip_before_action :verify_authenticity_token

  before_action :set_subject, only: [:subject_details, :update_subject, :remove_subject]

  def all_subjects
    subjects = Subject.all
    render json: subjects, status: :ok
  end

  def subject_details
    render json: @subject, status: :ok
  end

  def register_subject
    begin 
      result = SubjectService.create_subject(subject_params)
      if result[:success]
        rendor json: {message: "subject created successfully"}, status: :created
      else
        rendor json: {errors: result[:errors]}, status: :unprocessable_entity
      end
    rescue StandardError => e
      render json: {errors: e.message}, status: :internal_server_error
    end

    # subject = Subject.new(subject_params)
    # if subject.save
    #   render json: {message: "Subject created successfully"}, status: :created
    # else
    #   render json: {errors: subject.errors.full_messages}, status: :unprocessable_entity
    # end
  end

  def update_subject
    if @subject.update(subject_params)
      render json: @subject, status: :ok
    else
      render json: {errors: @subject.errors.full_messages}, status: :unprocessable_entity
    end
  end

  def remove_subject
    @subject.destroy
    head :no_content
  end

  # def enroll_student
  #   # Permit parameters before accessing them
  #   subject_id = params[:subject_id]
  #   student_id = params[:student_id]

  #   Rails.logger.debug "Received subject_id: #{subject_id}, student_id: #{student_id}"

  #   # Find the student by student_id
  #   student = Student.find_by(id: student_id)
  #   if student.nil?
  #     return render json: { error: "Student not found" }, status: :not_found
  #   end

  #   # Find the subject by subject_id
  #   @subject = Subject.find_by(id: subject_id)
  #   if @subject.nil?
  #     return render json: { error: "Subject not found" }, status: :not_found
  #   end

  #   # Check if the student is already enrolled in the subject
  #   if @subject.exams.joins(:students).where(students: { id: student.id }).exists?
  #     return render json: { error: "Student is already enrolled in this subject" }, status: :unprocessable_entity
  #   end

  #   # Create or get the first exam for the subject
  #   exam = @subject.exams.first || Exam.create!(subject: @subject)

  #   # Enroll the student in the exam
  #   exam.students << student
  #   render json: { message: "Student successfully enrolled in the subject" }, status: :ok
  # end

  def enroll_student
    # begin
    #   # Find the student
    #   student = Student.find_by(id: params[:student_id])
  
    #   # Check if the student exists
    #   if student.nil?
    #     return render json: { error: "Student not found" }, status: :not_found
    #   end
  
    #   # Find the subject
    #   @subject = Subject.find_by(id: params[:subject_id])
  
    #   # Check if the subject exists
    #   if @subject.nil?
    #     return render json: { error: "Subject not found" }, status: :not_found
    #   end
  
      # # Log the subject for debugging
      # Rails.logger.info "this is in enroll student ===>>> #{@subject}"
  
      # # Check if the student is already enrolled
      # if @subject.students.include?(student)
      #   render json: { message: "Student already enrolled in this subject" }, status: :unprocessable_entity
      # else
      #   # Associate the student with the subject
      #   @subject.students << student
      #   render json: { message: "Student successfully enrolled in the subject" }, status: :ok
    #   end
    # rescue StandardError => e
    #   render json: { message: e.message }, status: :internal_server_error
    # end
    begin
      result = SubjectService.enroll_student(params)
      render json: { message: result[:message] }, status: :ok
    rescue SubjectService::StudentNotFoundError, SubjectService::SubjectNotFoundError => e
      render json: { error: e.message }, status: :not_found
    rescue SubjectService::StudentAlreadyEnrolledError => e
      render json: { error: e.message }, status: :unprocessable_entity
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end

  end
  

  private 

  def subject_params
    params.require(:subject).permit(:name)
  end

  # def set_subject
  #   @subject = Subject.find_by(id: params[:subject_id])
  #   if @subject.nil?
  #     render json: { error: "Subject not found" }, status: :not_found
  #   end
  # end
  def set_subject
    # @subject = Subject.find_by(id: params[:subject_id])
    
    # # Return a proper error message if the subject doesn't exist
    # if @subject.nil?
    #   render json: { error: "Subject not found" }, status: :not_found and return
    # end
    @subject = Subject.find_by(id: params[:id])
    render json: { error: "Subject not found" }, status: :not_found if @subject.nil?
  end
  
end
