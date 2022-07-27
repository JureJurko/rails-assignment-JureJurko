module Api
  class UsersController < ApplicationController
    def index
      users = User.all

      if request.headers['HTTP_X_API_SERIALIZER'] == 'active_model_serializers'
        render json: users, serializer: ActiveModelSerializers::UserSerializer
      else
        render json: UserSerializer.render(User.all, root: 'users'), status: :ok
      end
    end

    def show
      user = User.find(params[:id])

      if request.headers['HTTP_X_API_SERIALIZER'] == 'active_model_serializers'
        render json: user, adapter: :json, serializer: ActiveModelSerializers::UserSerializer
      else
        render json: UserSerializer.render(user, root: 'user'), status: :ok
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
      user = User.find(params[:id])
      if user.update(permitted_params)
        render json: UserSerializer.render(user, root: 'user'), status: :ok
      else
        render json: { errors: user.errors }, status: :bad_request
      end
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
