# frozen_string_literal: true

class ApplicationEndpoint < Trailblazer::Endpoint
  Matcher = Dry::Matcher.new(
    forbidden: Dry::Matcher::Case.new(
      match: ->(result) {
        result.failure? && result['result.policy.default']&.failure?
      },
      resolve: ->(result) { result }
    ),
    invalid: Dry::Matcher::Case.new(
      match: ->(result) {
        result.failure? &&
          (result['result.contract.default']&.failure? || !result['result.contract.default'].errors.empty?)
      },
      resolve: ->(result) { result }
    ),
    success: Dry::Matcher::Case.new(
      match: ->(result) { result.success? },
      resolve: ->(result) { result }
    )
  )

  def matcher
    ApplicationEndpoint::Matcher
  end
end
