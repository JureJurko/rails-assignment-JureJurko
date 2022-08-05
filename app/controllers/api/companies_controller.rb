module Api
  class CompaniesController < ApplicationController
    def index
      render json: CompanySerializer.render(Company.all, root: 'companies'), status: :ok
    end

    def show
      company = Company.find(params[:id])

      render json: CompanySerializer.render(company, root: 'company'), status: :ok
    end

    def create
      return error_message if check_user || find_user.role != 'admin'

      company = Company.new(permitted_params)

      if company.save
        render json: CompanySerializer.render(company, root: 'company'), status: :created
      else
        render json: { errors: company.errors }, status: :bad_request
      end
    end

    def update
      return error_message if check_user || find_user.role != 'admin'

      company = Company.find(params[:id])
      if company.update(permitted_params)
        render json: CompanySerializer.render(company, root: 'company'), status: :ok
      else
        render json: { errors: company.errors }, status: :bad_request
      end
    end

    def destroy
      return error_message if check_user || find_user.role != 'admin'

      company = Company.find(params[:id])
      company.destroy
      head :no_content
    end

    private

    def permitted_params
      params.require(:company).permit(:name)
    end

    def error_message
      render json: { errors: { token: ['is invalid'] } }, status: :unauthorized
    end

    def find_user
      token = request.headers['Authorization']
      User.find_by(token: token)
    end

    def check_user
      token = request.headers['Authorization']
      User.find_by(token: token).nil?
    end
  end
end
