module ExceptionHandler
  extend ActiveSupport::Concern

  # Define custom error subclasses - rescue catches `StandardErrors`
  class AuthenticationError < StandardError; end
  class MissingToken < StandardError; end
  class InvalidToken < StandardError; end
  class WrongTiming < StandardError; end
  class EncodingError < StandardError; end

  included do
    # Define custom handlers
    rescue_from ExceptionHandler::AuthenticationError, with: :unauthorized_request
    rescue_from ExceptionHandler::MissingToken, with: :four_twenty_two
    rescue_from ExceptionHandler::InvalidToken, with: :four_twenty_two
    rescue_from ExceptionHandler::WrongTiming, with: :four_twenty_two
    rescue_from ExceptionHandler::EncodingError, with: :four_twenty_two

    rescue_from Mongoid::Errors::DocumentNotFound do |e|
      json_response({ message: e.problem }, :not_found)
    end
    rescue_from Mongoid::Errors::Validations do |e|
      json_response({ message: e.summary }, :unprocessable_entity)
    end
  end

  private

  # JSON response with message; Status code 422 - unprocessable entity
  def four_twenty_two(e)
    json_response({ message: e.message }, :unprocessable_entity)
  end

  # JSON response with message; Status code 401 - Unauthorized
  def unauthorized_request(e)
    json_response({ message: e.message }, :unauthorized)
  end
end