# frozen_string_literal: true

Dry::Validation::Schema.configure do |config|
  config.messages = :i18n
end

Dry::Validation::Schema::Form.configure do |config|
  config.messages = :i18n
end
