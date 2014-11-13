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
    end
  end
end