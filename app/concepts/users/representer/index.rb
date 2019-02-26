# frozen_string_literal: true

module Users::Representer
  class Index < ApplicationRepresenter
    attributes :first_name,
               :last_name,
               :email
  end
end
