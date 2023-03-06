# frozen_string_literal: true

class TokenController < ApplicationController
  require 'net/http'
  require 'json'
  require 'uri'

  def create
    client_id = ENV['CLIENT_ID']
    client_secret = ENV['CLIENT_SECRET']

    # Set up the authentication request
    uri = URI.parse("#{ENV['API_URL']}/v1/oauth2/token")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(uri.path)
    request.basic_auth(client_id, client_secret)
    request.set_form_data(
      {
        'grant_type' => 'client_credentials'
      }
    )

    # Send the authentication request and get the response
    response = http.request(request)

    # Parse the response and extract the access token
    parsed_response = JSON.parse(response.body)
    @token = parsed_response['access_token']
  end
end
