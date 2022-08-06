module Api
  class UsersController < ApplicationController
    def index
      return error_message if check_user
      return forbidden_message if find_user.role != 'admin'

      render json: UserSerializer.render(User.all, root: 'users'), status: :ok
    end

    def show
      return error_message if check_user

      user = User.find(params[:id])
      return forbidden_message if find_user.id != user.id && find_user.role != 'admin'

      render json: UserSerializer.render(user, root: 'user'), status: :ok
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
      return error_message if check_user

      user = User.find(params[:id])
      return forbidden_message if find_user.id != user.id && find_user.role != 'admin'

      update_user(user)
    end

    def destroy
      return error_message if check_user

      user = User.find(params[:id])
      return forbidden_message if find_user.id != params[:id] && find_user.role != 'admin'

      user.destroy
      head :no_content
    end

    private

    def permitted_params
      params.require(:user).permit(:first_name, :email, :last_name,
                                   :password, :password_digest, :token)
    end

    def check_user
      token = request.headers['Authorization']
      User.find_by(token: token).nil?
    end

    def error_message
      render json: { errors: { token: ['is invalid'] } }, status: :unauthorized
    end

    def find_user
      token = request.headers['Authorization']
      User.find_by(token: token)
    end

    def update_user(user)
      if user.update(permitted_params)
        render json: UserSerializer.render(user, root: 'user'), status: :ok
      else
        render json: { errors: user.errors }, status: :bad_request
      end
    end

    def forbidden_message
      render json: { errors: { resource: ['is forbidden'] } }, status: :forbidden
    end
  end
end
