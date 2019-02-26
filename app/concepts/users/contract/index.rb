# frozen_string_literal: true

module Users::Contract
  class Index < Reform::Form
    feature Reform::Form::Dry
    feature Coercion

    property :page, virtual: true, type: Types::Form::Int

    validation :default do
      optional(:page).maybe(:int?, gteq?: 1)
    end
  end
end
