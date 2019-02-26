# frozen_string_literal: true

class UsersController < AuthorizedController
  def index
    endpoint Users::Operation::Index, current_user: current_user
  end
end
