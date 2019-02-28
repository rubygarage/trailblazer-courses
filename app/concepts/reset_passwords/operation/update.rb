# frozen_string_literal: true

module ResetPasswords::Operation
  class Update < Trailblazer::Operation
    step Contract::Build(constant: ResetPasswords::Contract::Token)
    step Contract::Validate()

    step Rescue(JWT::InvalidAudError, JWT::DecodeError) {
      step :payload
    }
    step :model
    fail Macro::Semantic(failure: :gone)

    step Contract::Build(constant: ResetPasswords::Contract::Update)
    step Contract::Validate()
    step Contract::Persist()

    def payload(ctx, **)
      ctx[:payload], = Service::JWTAdapter.decode(ctx['contract.default'].token,
                                                  aud: 'reset_password',
                                                  verify_aud: true)
    end

    def model(ctx, payload:, **)
      ctx[:model] = User.find_by(id: payload['sub'].to_i)
    end
  end
end
