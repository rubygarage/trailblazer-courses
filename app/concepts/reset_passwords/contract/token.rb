# frozen_string_literal: true

module ResetPasswords::Contract
  class Token < Reform::Form
    feature Reform::Form::Dry

    property :token, virtual: true

    validation do
      required(:token).filled(:str?)
    end
  end
end
