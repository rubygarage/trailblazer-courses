# frozen_string_literal: true

module Lib::Representer
  class ErrorRepresenter < JSONAPI::Serializable::Error
    detail do
      @message
    end

    source do
      pointer "/data/attributes/#{@field.to_s.dasherize}" unless @field.nil?
    end
  end
end
