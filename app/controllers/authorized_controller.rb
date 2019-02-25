# frozen_string_literal: true

class AuthorizedController < ApplicationController
  before_action :authorize_request!
end
