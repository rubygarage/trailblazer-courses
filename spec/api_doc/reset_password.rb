# frozen_string_literal: true

module ApiDoc
  module ResetPassword
    extend ::Dox::DSL::Syntax

    document :api do
      resource 'Reset Password' do
        endpoint '/reset_password'
        group 'Reset Password'
      end
    end

    document :show do
      action 'Checks validity of token'
    end

    document :create do
      action 'Creates reset password token'
    end

    document :update do
      action "Resets user's password"
    end
  end
end
