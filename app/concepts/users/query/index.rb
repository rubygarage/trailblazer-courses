# frozen_string_literal: true

module Users::Query
  class Index
    def self.call(relation = User.all)
      relation.where(is_admin: false).order(:last_name, :first_name, :created_at)
    end
  end
end
