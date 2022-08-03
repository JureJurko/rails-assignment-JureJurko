require 'pry'
module Api
  class SessionController < ApplicationController
    def create
      payload = JSON.parse(request.body.read)
      session = Session.new(email: payload['session']['email'],
                            password: payload['session']['password'])
      if session.valid?
        valid_response(session)
      else
        bad_request
      end
    end

    private

    def valid_response(session)
      render json: { session: { token: current_user(session).token,
                                user: UserSerializer.render(current_user(session)) } }, status: :ok
    end

    def bad_request
      render json: { errors: { credentials: ['are invalid'] } }, status: :bad_request
    end

    def current_user(session)
      binding pry
      user.find { |usr| usr.email == session.email }
    end
  end
end
