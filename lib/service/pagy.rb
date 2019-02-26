# frozen_string_literal: true

module Service
  class Pagy
    class << self
      include ::Pagy::Backend

      def call(collection, page:, **options)
        # emulating controller environment for Pagy helper: https://github.com/ddnexus/pagy/blob/master/lib/pagy/backend.rb#L20
        @params = { page: page }
        pagy(collection, options)
      end

      private

      attr_reader :params
    end
  end
end
