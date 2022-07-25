module Api
  class CompaniesController < ApplicationController
    def index
      render json: CompanySerializer.render(Company.all, root: 'companies'), status: :ok
    end

    def show
      company = Company.find(params[:id])

      render json: CompanySerializer.render(company, root: 'companies'), status: :ok
    end

    def create
      company = Company.new(permitted_params)

      if company.save
        render json: CompanySerializer.render(company, root: 'companies'), status: :created
      else
        render json: company.errors, status: :bad_request
      end
    end

    def update
      company = Company.find(params[:id])
      company.update(permitted_params)

      render json: CompanySerializer.render(company, root: 'companies'), status: :ok
    end

    def destroy
      company = Company.find(params[:id])
      company.destroy
      head :no_content
    end

    private

    def permitted_params
      params.require(:company).permit(:name)
    end
  end
end
