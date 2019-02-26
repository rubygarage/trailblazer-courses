# frozen_string_literal: true

module Lib::Policy
  class AdministratorGuard
    def call(_ctx, current_user:, **)
      current_user.is_admin
    end
  end
end
