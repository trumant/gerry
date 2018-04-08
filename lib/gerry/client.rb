require 'httparty'
require 'json'

module Gerry
  class Client
    include HTTParty
    headers 'Accept' => 'application/json'

    require_relative 'client/access'
    require_relative 'client/accounts'
    require_relative 'client/changes'
    require_relative 'client/groups'
    require_relative 'client/projects'
    require_relative 'client/request'

    include Access
    include Accounts
    include Changes
    include Groups
    include Projects
    include Request

    def set_auth_type(auth_type)
      @auth_type = auth_type
    end

    def initialize(url, username = nil, password = nil)
      self.class.base_uri(url)
      @auth_type = :digest_auth

      if username && password
        @username = username
        @password = password
      else
        require 'netrc'
        @username, @password = Netrc.read[URI.parse(url).host]
      end
    end
  end
end
