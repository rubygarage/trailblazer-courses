# frozen_string_literal: true

module Accounts::Passwords::Contract
  class Update < Reform::Form
    feature Reform::Form::Dry

    property :old_password, virtual: true
    property :password, readable: false
    property :password_confirmation

    validation :default do
      configure do
        config.namespace = :user_password
      end

      required(:old_password).filled(:str?)
      required(:password).filled(
        :str?,
        min_size?: Constants::Shared::PASSWORD_MIN_LENGTH,
        format?: Constants::Shared::PASSWORD_REGEX
      ).confirmation
    end
  end
end
