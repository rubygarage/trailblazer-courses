# frozen_string_literal: true

module Authentication
  def self.included(base)
    base.class_eval do
      rescue_from UnauthorizedError do
        exception_respond(:unauthorized, I18n.t('errors.unauthenticated'))
      end
    end
  end

  def authorize_request!
    @auth_payload = JSON.parse(request.headers["Authorization"] || '')
    raise UnauthorizedError if @auth_payload['user_id'].blank?
  rescue JSON::ParserError
    raise UnauthorizedError
  end

  def current_user
    @current_user ||= User.find_by(id: auth_payload['user_id'])
  end

  private

  attr_reader :auth_payload

  def exception_respond(status, message)
    errors = { base: [message] }

    render json: { errors: errors }, status: status
  end

  class UnauthorizedError < StandardError; end
end
