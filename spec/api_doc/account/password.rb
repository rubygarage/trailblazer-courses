# frozen_string_literal: true

module ApiDoc
  module Account
    module Password
      extend ::Dox::DSL::Syntax

      document :api do
        resource 'Password' do
          endpoint '/account/password'
          group 'User Account'
        end

        group 'User Account' do
          desc 'User account'
        end
      end

      document :update do
        action 'User changes its password'
      end
    end
  end
end
