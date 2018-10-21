module Api
  module V1
    class CourseUsersController < ActionController::API
      before_action :custom_authenticate_user!

      include CourseUsersHelper

      # Lista de cursos disponibles para un usuario (los cursos a los que no está asociado)
      def show_disp
        @courses = Course.where(["id NOT IN (SELECT course_id FROM course_users WHERE user_id = ?)", @current_user.id])
        render json: {cursos: @courses}, status: :ok
      end

      # Lista de cursos actuales (los cursos a los que está asociado y no ha terminado)
      def show_act
        @courseusers = CourseUser.where(["user_id = ? AND fechaFin IS NULL", @current_user.id]).order("created_at DESC")
        render json: {cursos: @courseusers.as_json(include: [:course])}
      end

      # Lista de cursos finalizados (los cursos a los que está asociado y ya terminó)
      def show_hist
        @courseusers = CourseUser.where(["user_id = ? AND fechaFin IS NOT NULL", @current_user.id]).order("created_at DESC")
        render json: {cursos: @courseusers.as_json(include: [:course])}
      end

      def inscribircurso
        enroll
        render json: {courseuser: @inscripcion}, status: :ok
      end

      def finalizarcurso
        finalizar
        render json: {courseuser: @inscripcion}, status: :ok
      end
    end
  end
end
