require 'gemnasium/gitlab_service/client'
require 'gemnasium/gitlab_service/errors'
require 'rugged'

module Gemnasium
  SUPPORTED_DEPENDENCY_FILES = /(Gemfile|Gemfile\.lock|.*\.gemspec|package\.json|npm-shrinkwrap\.json|setup\.py|requirements\.txt|requires\.txt|composer\.json|composer\.lock)$/
  module GitlabService
    class << self

      def execute(options)
        branch_name = options[:ref].to_s.sub(/\Arefs\/(heads|tags)\//, '')
        repo = Rugged::Repository.new(options[:repo])
        client = Gemnasium::GitlabService::Client.new(options)
        files = get_sha1s(repo, options[:after])
        # Ask to Gemnasium server which dependency file should be uploaded (new or modified)
        comparison_results = client.compare_sha1s(options[:token], branch_name, files)
        files_to_upload = comparison_results['to_upload']
        unless files_to_upload.empty?
          files = get_files_content(repo, options[:after], files, files_to_upload)
          # Upload requested dependency files content
          upload_summary = client.upload_files(options[:token], branch_name, files)
        end
      end

    private

      def get_sha1s(repo, after)
        tree = repo.lookup(after).tree
        tree.walk(:postorder).inject({}) do |h, el|
          if el.last[:name].match SUPPORTED_DEPENDENCY_FILES
            h[el.first + el.last[:name]] = el.last[:oid]
          end
          h
        end
      end

      def get_files_content(repo, after, files, files_to_upload)
        files.inject([]) do |a, file|
          if files_to_upload.include? file.first
            blob = repo.lookup file.last
            a.push({"filename" => file.first, "sha" => blob.oid, "content" => blob.content})
          end
          a
        end
      end

    end
  end
end
