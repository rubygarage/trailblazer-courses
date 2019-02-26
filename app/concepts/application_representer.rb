# frozen_string_literal: true

class ApplicationRepresenter < JSONAPI::Serializable::Resource
  extend JSONAPI::Serializable::Resource::KeyFormat
  key_format ->(key) { key.to_s.dasherize }

  type do
    @object.class.name.pluralize.underscore.dasherize
  end
end
