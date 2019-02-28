# frozen_string_literal: true

module ResetPasswords::Operation
  class Create < Trailblazer::Operation
    pass Macro::Semantic(success: :created)

    step Contract::Build(constant: ResetPasswords::Contract::Create)
    step Contract::Validate(), fail_fast: true

    step Model(User, :find_by_email, :email), Output(:failure) => 'End.success'
    step :send_restore_password_instructions

    def send_restore_password_instructions(_ctx, model:, **)
      token = Lib::Service::TokenCreator::ResetPassword.call(model)
      UserMailer.reset_password(model, token).deliver_later
    end
  end
end
