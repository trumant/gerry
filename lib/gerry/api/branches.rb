# frozen_string_literal: true

module Gerry
  module Api
    module Branches
      ##
      # Get the branches of project
      #
      def branches(project_name)
        get("/projects/#{project_name}/branches")
      end

      # Get the projects that start with the specified prefix
      # and accessible by the caller.
      #
      # @param [String] name the project name.
      # @return [Hash] the projects.
      def branch(project_name, branch_name)
        get("/projects/#{project_name}/branches/#{branch_name}")
      end

      ##
      # create branch that derived from branch name or revision
      #
      #  example: create_branch('foo', 'master', 'stable')
      #           create_branch('foo', 'revision', 'stable')
      #
      def create_branch(project_name, source, branch)
        # try source as ref
        body = { ref: source }
        put("/projects/#{project_name}/branches/#{branch}", body)
      rescue Gerry::Api::Request::RequestError
        # try source as revision
        body = { revision: source }
        put("/projects/#{project_name}/branches/#{branch}", body)
      end

      ##
      # Gets the reflog of a certain branch.
      def branch_reflog(project_name, branch, number)
        get("/projects/#{project_name}/branches/#{branch}/reflog?n=#{number}")
      end
    end
  end
end
