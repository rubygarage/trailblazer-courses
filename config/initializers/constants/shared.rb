# frozen_string_literal: true

module Constants
  module Shared
    PASSWORD_REGEX = %r{(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])[a-zA-Z0-9!\$%&,\(\)\*\+-\.\/;:<=>?\[\\\]\^_{|}~#"@]+}i.freeze
    PASSWORD_MIN_LENGTH = 8
  end
end
