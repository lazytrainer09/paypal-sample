# frozen_string_literal: true

class PaymentsController < ApplicationController
  def index
    @sample = 'index, hello!'
  end

  def create
    redirect_to payments_path
  end
end
