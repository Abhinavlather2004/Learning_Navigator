class Api::V1::StudentsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_student, only: [:student_details, :modify_student, :remove_student]

  def all_students
    students = Student.all
    render json: students, status: :ok
  end

  def student_details
    render json: @student, status: :ok
  end

  def register_student
    begin
      result = StudentService.create_student(student_params)
      if result[:success]
        render json: { message: "Student created successfully" }, status: :created
      else
        render json: { errors: result[:errors] }, status: :unprocessable_entity
      end
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end
  end

  def modify_student
    if @student.update(student_params)
      render json: @student, status: :ok
    else
      render json: { errors: @student.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def remove_student
    @student.destroy
    head :no_content
  end

  private
  def student_params
    params.require(:student).permit(:registration_id, :name)
  end

  def set_student
    @student = Student.find_by(id: params[:id])
    render json: { error: "Student not found" }, status: :not_found if @student.nil?
  end
  
end
