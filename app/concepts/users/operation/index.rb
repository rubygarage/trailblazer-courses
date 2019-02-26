# frozen_string_literal: true

module Users::Operation
  class Index < Trailblazer::Operation
    step Policy::Guard(Lib::Policy::AdministratorGuard.new), fail_fast: true
    step Contract::Build(constant: Users::Contract::Index)
    step Contract::Validate(), fail_fast: true

    step :model
    step :overflow?
    fail :overflow
    step :prepare_renderer

    def model(ctx, **)
      ctx[:pagy], ctx[:model] = ::Service::Pagy.call(Users::Query::Index.call,
                                                     page: ctx['contract.default'].page)
    end

    def overflow?(_ctx, pagy:, **)
      !pagy.overflow?
    end

    def overflow(ctx, **)
      ctx['contract.default'].errors.add(:page, I18n.t('errors.pagination_overflow'))
    end

    def prepare_renderer(ctx, pagy:, **)
      employees_path = Rails.application.routes.url_helpers.users_path
      ctx[:renderer_options] = {
        class: {
          User: Users::Representer::Index
        },
        links: Lib::Representer::Paginator.call(resource_path: employees_path, pagy: pagy)
      }
    end
  end
end
