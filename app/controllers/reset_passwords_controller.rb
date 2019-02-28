# frozen_string_literal: true

class ResetPasswordsController < ApplicationController
  def show
    endpoint ResetPasswords::Operation::Show
  end

  def create
    endpoint ResetPasswords::Operation::Create
  end

  def update
    endpoint ResetPasswords::Operation::Update
  end
end
