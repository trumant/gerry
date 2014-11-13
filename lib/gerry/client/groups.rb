require 'json'

module Gerry
  class Client
    module Groups
      # Get all groups
      #
      # @return [Hash] the groups
      def groups
        url = '/groups/'
        get(url)
      end

      # Get all members for a group
      #
      # @return [Array] the members
      def group_members(group_id)
        url = "/groups/#{group_id}/members/"
        get(url)
      end

      # Create a new group
      #
      # @return [Hash] the group details
      def create_group(name, description, visible, owner_id=nil)
        url = "/groups/#{name}"
        body = {
          description: description,
          visible_to_all: visible,
        }
        body[:owner_id] = owner_id unless owner_id.nil? || owner_id.empty?
        put(url, body)
      end
    end
  end
end