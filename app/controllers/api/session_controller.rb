module Api
  class SessionController < ApplicationController
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

    private

    def error_response
      render json: { errors: { credentials: ['are invalid'] } }, status: :bad_request
    end

    def ok_response(session)
      render json: { session: { token: session.user.token,
                                user: {
                                  id: session.user.id,
                                  created_at: session.user.created_at,
                                  email: session.user.email,
                                  first_name: session.user.first_name,
                                  last_name: session.user.last_name,
                                  updated_at: session.user.updated_at
                                } } },
             status: :created
    end
  end
end
