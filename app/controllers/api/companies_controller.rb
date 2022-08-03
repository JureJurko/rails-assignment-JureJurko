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
      render json: error_message, status: :unauthorized if check_user.role != 'admin'
      company = Company.new(permitted_params)

      if company.save
        render json: CompanySerializer.render(company, root: 'company'), status: :created
      else
        render json: { errors: company.errors }, status: :bad_request
      end
    end

    def update
      render json: error_message, status: :unauthorized if check_user.role != 'admin'
      company = Company.find(params[:id])
      if company.update(permitted_params)
        render json: CompanySerializer.render(company, root: 'company'), status: :ok
      else
        render json: { errors: company.errors }, status: :bad_request
      end
    end

    def destroy
      render json: error_message, status: :unauthorized if check_user.role != 'admin'
      company = Company.find(params[:id])
      company.destroy
      head :no_content
    end

    private

    def permitted_params
      params.require(:company).permit(:name)
    end

    def check_user
      token = request.headers['Authorization']
      User.find_by(token: token)
    end

    def error_message
      { errors: { token: ['is invalid'] } }
    end
  end
end
