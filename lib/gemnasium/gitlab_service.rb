require 'gemnasium/gitlab_service/client'
require 'gemnasium/gitlab_service/errors'
require 'gitlab_git'

module Gemnasium
  SUPPORTED_DEPENDENCY_FILES = /(Gemfile|Gemfile\.lock|.*\.gemspec|package\.json|npm-shrinkwrap\.json|setup\.py|requirements\.txt|requires\.txt|composer\.json|composer\.lock)$/
  module GitlabService
    class << self

      def execute(options)
        branch_name = options[:ref].to_s.sub(/\Arefs\/(heads|tags)\//, '')
        repo = ::Gitlab::Git::Repository.new(options[:repo])
        modified_files = get_modified_files(repo, options[:before], options[:after])
        unless modified_files.empty?
          dependency_files_hashes = get_dependency_files_hashes(repo, options[:after], modified_files)
          client = Gemnasium::GitlabService::Client.new(options)
          # Ask to Gemnasium server which dependency file should be uploaded (new or modified)
          comparison_results = client.compare_sha1s(options[:token], branch_name, dependency_files_hashes)
          files_to_upload = comparison_results['to_upload']
          unless files_to_upload.empty?
            files = get_files_data(repo, options[:after], files_to_upload)
            # Upload requested dependency files content
            upload_summary = client.upload_files(options[:token], branch_name, files)
          end
        end
      end

    private

      def get_modified_files(repo, before, after)
        commited_files = repo.commits_between(before, after).map do |commits|
           commits.diffs.select{|e| e}.map{|diff| diff.b_path}
        end
        commited_files.flatten.uniq.grep(SUPPORTED_DEPENDENCY_FILES)
      end

      def get_dependency_files_hashes(repo, after, modified_files)
        new_dependency_files = ::Gitlab::Git::Tree.where(repo, after).select{|file| modified_files.include? file.name}
        new_dependency_files.inject({}){|h, file| h[file.name] = file.id; h}
      end

      def get_files_data(repo, after, files_to_upload)
        files_to_upload.inject([]) do |a, file|
          blob = ::Gitlab::Git::Blob.find(repo, after, file)
          a.push({"filename" => blob.name, "sha" => blob.id, "content" => blob.data})
          a
        end
      end
    end

  end
end
