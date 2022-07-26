module Api
  class UsersController < ApplicationController
    def index
      render json: UserSerializer.render(User.all, root: 'users'), status: :ok
    end

    def show
      user = User.find(params[:id])

      render json: UserSerializer.render(user, root: 'user'), status: :ok
    end

    def create
      user = User.new(permitted_params)

      if user.save
        render json: UserSerializer.render(user, root: 'user'), status: :created
      else
        render json: user.errors, status: :bad_request
      end
    end

    def update
      user = User.find(params[:id])
      user.update(permitted_params)

      render json: UserSerializer.render(user, root: 'user'), status: :ok
    end

    def destroy
      user = User.find(params[:id])
      user.destroy
      head :no_content
    end

    private

    def permitted_params
      params.require(:user).permit(:first_name, :email, :last_name)
    end
  end
end
