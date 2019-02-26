# frozen_string_literal: true

module Lib::Representer
  class Paginator
    def self.call(resource_path:, pagy:)
      {
        self: "#{resource_path}?page=#{pagy.page}",
        first: resource_path,
        next: "#{resource_path}?page=#{pagy.next}",
        prev: "#{resource_path}?page=#{pagy.prev}",
        last: "#{resource_path}?page=#{pagy.pages}"
      }
    end
  end
end
