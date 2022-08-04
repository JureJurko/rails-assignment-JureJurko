module Api
  class UsersController < ApplicationController
    def index
      error_message if check_user.nil? || check_user.role != 'admin'

      render json: UserSerializer.render(User.all, root: 'users'), status: :ok
    end

    def show
      error_message if check_user.nil?

      if check_user.role == 'admin' || check_user.id == params[:id]
        render json: UserSerializer.render(User.find(params[:id]), root: 'user'), status: :ok
      else
        error_message
      end
    end

    def create
      user = User.new(permitted_params)

      if user.save
        render json: UserSerializer.render(user, root: 'user'), status: :created
      else
        render json: { errors: user.errors }, status: :bad_request
      end
    end

    def update
      error_message if check_user.nil?

      valid_to_update_or_delete
      user = User.find(params[:id])
      if user.update(permitted_params)
        render json: UserSerializer.render(user, root: 'user'), status: :ok
      else
        render json: { errors: user.errors }, status: :bad_request
      end
    end

    def destroy
      error_message if check_user.nil?

      valid_to_update_or_delete
      user = User.find(params[:id])
      user.destroy
      head :no_content
    end

    private

    def permitted_params
      params.require(:user).permit(:first_name, :email, :last_name)
    end

    def check_user
      token = request.headers['Authorization']
      User.find_by(token: token)
    end

    def error_message
      render json: { errors: { token: ['is invalid'] } }, status: :unauthorized
    end

    def valid_to_update_or_delete
      return true if check_user.role == 'admin' || check_user.id == params[:id]

      error_message
    end
  end
end
