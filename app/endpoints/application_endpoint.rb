# frozen_string_literal: true

class ApplicationEndpoint < Trailblazer::Endpoint
  Matcher = Dry::Matcher.new(
    destroyed: Dry::Matcher::Case.new(
      match: ->(result) {
        result.success? && result[:model].try(:destroyed?)
      },
      resolve: ->(result) { result }
    ),
    forbidden: Dry::Matcher::Case.new(
      match: ->(result) {
        result.failure? && result['result.policy.default']&.failure?
      },
      resolve: ->(result) { result }
    ),
    invalid: Dry::Matcher::Case.new(
      match: ->(result) {
        result.failure? &&
          (result['result.contract.default']&.failure? || result['result.contract.default'].present?) ||
          result[:errors].present?
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
