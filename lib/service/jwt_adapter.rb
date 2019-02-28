# frozen_string_literal: true

module Service
  class JWTAdapter
    SECRET_KEY = Rails.application.credentials.secret_jwt_encryption_key

    def self.encode(payload)
      JWT.encode(payload, SECRET_KEY)
    end

    def self.decode(token, verify: true, **options)
      JWT.decode(token, SECRET_KEY, verify, **options)
    end
  end
end
