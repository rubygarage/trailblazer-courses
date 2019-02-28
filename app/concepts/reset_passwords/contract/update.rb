# frozen_string_literal: true

module ResetPasswords::Contract
  class Update < Reform::Form
    feature Reform::Form::Dry

    PASSWORD_REGEX = %r{(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])[a-zA-Z0-9!\$%&,\(\)\*\+-\.\/;:<=>?\[\\\]\^_{|}~#"@]+}i.freeze
    PASSWORD_MIN_LENGTH = 8

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
        format?: PASSWORD_REGEX,
        min_size?: PASSWORD_MIN_LENGTH
      ).confirmation
    end
  end
end
