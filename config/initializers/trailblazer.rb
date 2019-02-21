# frozen_string_literal: true

require 'reform'
require 'reform/form/dry'
require 'reform/form/coercion'

Rails.application.configure do
  config.trailblazer.enable_loader = false
  config.trailblazer.application_controller = 'ApiController'
end
