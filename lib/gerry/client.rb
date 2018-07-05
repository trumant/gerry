# frozen_string_literal: true

require 'httparty'
require 'json'

require_relative 'api/access'
require_relative 'api/accounts'
require_relative 'api/changes'
require_relative 'api/groups'
require_relative 'api/projects'
require_relative 'api/request'
require_relative 'api/branches'


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
  
  class Client
    include HTTParty
    headers 'Accept' => 'application/json'

    include Api::Access
    include Api::Accounts
    include Api::Changes
    include Api::Groups
    include Api::Projects
    include Api::Branches
    include Api::Request

    def set_auth_type(auth_type)
      @auth_type = auth_type
    end

    def initialize(url, username = nil, password = nil)
      self.class.base_uri(url)
      @auth_type = :digest_auth

      if username && password
        @username = username
        @password = password
      end
    end
  end
end

