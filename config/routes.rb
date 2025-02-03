Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
     
      get 'students', to: 'students#all_students'
      get 'students/:id', to: 'students#student_details'
      post 'students/register', to: 'students#register_student'
      put 'students/:id/modify', to: 'students#modify_student'
      delete 'students/:id/remove', to: 'students#remove_student'

      
      get 'subjects', to: 'subjects#all_subjects'
      get 'subjects/:id', to: 'subjects#subject_details'
      post 'subjects/register', to: 'subjects#register_subject'
      put 'subjects/:id/modify', to: 'subjects#update_subject'
      delete 'subjects/:id/remove', to: 'subjects#remove_subject'

    
      get 'exams', to: 'exams#all_exams'
      get 'exams/:id', to: 'exams#exam_details'
      post 'exams/register', to: 'exams#register_exam'
      put 'exams/:id/modify', to: 'exams#update_exam'
      delete 'exams/:id/remove', to: 'exams#delete_exam'

     
      post 'exams/:exam_id/register/:student_id', to: 'exams#register'
      post 'subjects/:subject_id/enroll/:student_id', to: 'subjects#enroll_student'

    end
  end
end
