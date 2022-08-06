module Api
  class SessionsController < ApplicationController
    def create
      payload = JSON.parse(request.body.read)

      session = Session.new(email: payload['session']['email'],
                            password: payload['session']['password'])

      if session.valid?
        ok_response(session)
      else
        error_response
      end
    end

    def destroy
      return error_message if check_user
      token = request.headers['Authorization']
      user = User.find_by(token: token)
      user.regenerate_token
      head :no_content
    end

    private

    def error_response
      render json: { errors: { credentials: ['are invalid'] } }, status: :bad_request
    end

    def ok_response(session)
      render json: { session: { token: session.user.token,
                                user: { id: session.user.id,
                                        created_at: session.user.created_at,
                                        email: session.user.email,
                                        first_name: session.user.first_name,
                                        last_name: session.user.last_name,
                                        role: session.user.role,
                                        updated_at: session.user.updated_at } } }, status: :created
    end

    def error_message
      render json: { errors: { token: ['is invalid'] } }, status: :unauthorized
    end

    def check_user
      token = request.headers['Authorization']
      User.find_by(token: token).nil?
    end
  end
end
