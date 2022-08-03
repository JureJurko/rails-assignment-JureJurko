class ApplicationController < ActionController::API
  before_action :require_json

  private
  def require_json
    return if request.headers['Content-Type'] == 'application/json'

    render json: { errors: { content_type: ['not recognized'] } },
           status: :unsupported_media_type
  end
end
