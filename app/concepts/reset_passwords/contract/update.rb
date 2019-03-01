# frozen_string_literal: true

module ResetPasswords::Contract
  class Update < Reform::Form
    feature Reform::Form::Dry

    property :token, virtual: true
    property :password, readable: false
    property :password_confirmation, virtual: true

    validation do
      configure do
        config.namespace = :user_password
      end

      required(:token).filled(:str?)
      required(:password).filled(
        :str?,
        format?: Constants::Shared::PASSWORD_REGEX,
        min_size?: Constants::Shared::PASSWORD_MIN_LENGTH
      ).confirmation
    end
  end
end
