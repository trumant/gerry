# frozen_string_literal: true

require_relative 'client'

module Gerry
  ##
  # Client for gerrit request api
  #
  # - for anonymout user
  #  client = Gerry::Client.new('http://gerrit.example.com')
  # - for user/password
  #  client = Gerry::Client.new('http://gerrit.example.com', 'username', 'password')
  #  
  #   
  
  class Project
    def initialize(client)
      @client = client
    end
x
    def create_branch
    end
  end
end

