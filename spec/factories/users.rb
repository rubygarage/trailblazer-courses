# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { FFaker::Internet.email }
    password { 'Password1' }
    first_name { FFaker::Name.first_name }
    last_name { FFaker::Name.last_name }
    is_admin { false }
  end
end
