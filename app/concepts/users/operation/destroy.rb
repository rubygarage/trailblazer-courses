# frozen_string_literal: true

module Users::Operation
  class Destroy < Trailblazer::Operation
    step Policy::Guard(Lib::Policy::AdministratorGuard.new), fail_fast: true

    step :not_self?
    fail :handle_self_destroy
    step Model(User, :find_by)
    step :destroy

    def not_self?(_ctx, params:, current_user:, **)
      params[:id].to_i != current_user.id
    end

    def handle_self_destroy(ctx, **)
      ctx[:errors] = { base: [I18n.t('errors.self_removal')] }
    end

    def destroy(_ctx, model:, **)
      model.destroy
    end
  end
end
