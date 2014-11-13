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
    end
  end
end