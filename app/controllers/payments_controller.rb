# frozen_string_literal: true

class PaymentsController < ApplicationController
  require 'net/http'
  require 'json'
  require 'uri'
  # require 'securerandom'

  # RANDOM = SecureRandom.uuid

  def index; end

  def create
    # Set up the authentication request
    uri = URI.parse("#{ENV['API_URL']}/v2/checkout/orders")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri.path)

    request['Authorization'] = "Bearer #{ENV['AUTH_TOKEN']}"
    request['Content-Type'] = 'application/json'
    # request['PayPal-Request-Id'] = RANDOM

    request.body = {
      intent: 'CAPTURE',
      purchase_units: [{
        amount: {
          currency_code: 'JPY',
          value: '1000.00'
        }
        # reference_id: "ref-#{RANDOM}"
      }]
    }.to_json
    response = http.request(request)

    parsed_response = JSON.parse(response.body)
    render json: { orderID: parsed_response['id'] }
  end

  def capture
    # Set up the authentication request
    uri = URI.parse("#{ENV['API_URL']}/v2/checkout/orders/#{params[:id]}/capture")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri.path)

    request['Authorization'] = "Bearer #{ENV['AUTH_TOKEN']}"
    request['Content-Type'] = 'application/json'
    # request['PayPal-Request-Id'] = RANDOM
    request.body = {}.to_json

    response = http.request(request)

    parsed_response = JSON.parse(response.body)
    render json: { status: parsed_response['status'] }
  end
end
