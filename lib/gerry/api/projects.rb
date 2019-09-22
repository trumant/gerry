module Gerry
  module Api
    module Projects
      # Get the projects accessible by the caller.
      #
      # @return [Hash] the projects.
      def projects
        get('/projects/')
      end

      # Get the projects that start with the specified prefix
      # and accessible by the caller.
      #
      # @param [String] name the project name.
      # @return [Hash] the projects.
      def find_project(name)
        get("/projects/#{name}")
      end

      # Get the symbolic HEAD ref for the specified project.
      #
      # @param [String] project the project name.
      # @return [String] the current ref to which HEAD points to.
      def get_head(project)
        get("/projects/#{project}/HEAD")
      end

      # Set the symbolic HEAD ref for the specified project to
      # point to the specified branch.
      #
      # @param [String] project the project name.
      # @param [String] branch the branch to point to.
      # @return [String] the new ref to which HEAD points to.
      def set_head(project, branch)
        url = "/projects/#{project}/HEAD"
        body = {
          ref: 'refs/heads/' + branch
        }
        put(url, body)
      end

      ##
      # lists the access rights for signle project
      def project_access(project)
        get("/projects/#{project}/access")
      end

      def create_project_access(project, permissions)
        access = {
          'add' => permissions
        }
        post("/projects/#{project}/access", access)
      end

      def remove_project_access(project, permissions)
        access = {
          'remove' => permissions
        }
        post("/projects/#{project}/access", access)
      end

      ##
      # Retrieves a commit of a project.
      def project_commit(project, commit_id)
        get("/projects/#{project}/commits/#{commit_id}")
      end

      def project_file(project, commit_id, file_id)
        get("/projects/#{project}/commits/#{commit_id}/files/#{file_id}/content")
      end
    end
  end
end
