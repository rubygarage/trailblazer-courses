# frozen_string_literal: true

module ResetPasswords::Operation
  class Show < Trailblazer::Operation
    pass Macro::Semantic(failure: :gone)

    step Contract::Build(constant: ResetPasswords::Contract::Token)
    step Contract::Validate()

    step Rescue(JWT::InvalidAudError, JWT::DecodeError) {
      step :token_valid?
    }

    def token_valid?(ctx, **)
      Service::JWTAdapter.decode(ctx['contract.default'].token, aud: 'reset_password', verify_aud: true)
    end
  end
end
