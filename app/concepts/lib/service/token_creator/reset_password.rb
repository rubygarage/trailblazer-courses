# frozen_string_literal: true

module Lib::Service::TokenCreator
  class ResetPassword
    DEFAULT_TOKEN_EXPIRATION = 24.hours

    def self.call(model)
      ::Service::JWTAdapter.encode(
        aud: 'reset_password',
        sub: model.id,
        exp: DEFAULT_TOKEN_EXPIRATION.from_now.to_i
      )
    end
  end
end
