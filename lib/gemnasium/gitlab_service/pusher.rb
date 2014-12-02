require 'gemnasium/gitlab_service/client'
require 'rugged'

module Gemnasium
  module GitlabService

    # Push all dependency files of a git repo to Gemnasium.
    #
    class Pusher

      DependencyFile = Struct.new(:path, :sha, :content)

      attr_reader :repo_path, :commit_sha, :branch_name
      attr_reader :project_slug, :client

      def initialize(options = {})
        @repo_path = options.fetch(:repo)
        @commit_sha = options.fetch(:after)
        @branch_name = options.fetch(:ref).to_s.sub(/\Arefs\/(heads|tags)\//, '')
        @project_slug = options.fetch(:token)
        @client ||= options.fetch(:client){ Gemnasium::GitlabService::Client.new(options) }
      end

      # Push all dependency files
      #
      def call
        if dependency_files.any?
          client.upload_files(project_slug, dependency_files)
        end
      end

      private

      # Return the dependency files as an array
      #
      def dependency_files
        @dependency_files = (
          walker.inject([]) do |files, entry|
            files << convert_entry(entry) if is_entry_supported?(entry)
            files
          end
        )
      end

      # Return a Rugged::Walker that goes through the entries of the commit
      #
      def walker
        repo.lookup(commit_sha).tree.walk(:postorder)
      end

      # Return a Rugged::Repository
      #
      def repo
        @repo ||= Rugged::Repository.new(repo_path)
      end

      # Convert a commit entry for the Gemnasium client
      #
      def convert_entry(entry)
        path, oid = entry.last.values_at(:name, :oid)
        blob = repo.lookup oid
        DependencyFile.new path, blob.oid, blob.text
      end

      # Tell whether or not a commit entry is a supported dependency file
      #
      def is_entry_supported?(entry)
        path = entry.last[:name]
        path.match supported_path_regexp
      end

      # Return regexp that matches the path of a supported dependency file
      #
      def supported_path_regexp
        /(Gemfile|Gemfile\.lock|.*\.gemspec|package\.json|npm-shrinkwrap\.json|setup\.py|requirements\.txt|requires\.txt|composer\.json|composer\.lock)$/
      end

    end
  end
end
