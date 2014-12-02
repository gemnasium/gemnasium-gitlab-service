require "gemnasium/gitlab_service/connection"
require 'json'

module Gemnasium
  module GitlabService
    class Client

      def initialize(options={})
        @connection = Gemnasium::GitlabService::Connection.new(options)
      end

      # Updates or creates the dependency files.
      #
      # @params project [String] Identifier of the project
      #         files [Hash] files to upload; a file respond to :path, :sha and :content

      def upload_files(project, commit_sha, files)
        payload = files.map do |f|
          { "path" => f.path, "sha" => f.sha, "content" => Base64.encode64(f.content) }
        end
        extra_headers = { 'X-Gms-Revision' => commit_sha }
        request(:post, "projects/#{ project }/dependency_files", payload, extra_headers)
      end

      private

      # Issue a HTTP request
      #
      # @params method [String] Method of the request
      #         path [String] Path of the request
      #         payload [Hash] payload of a POST request
      #         extra_headers [Hash] extra HTTP headers
      #
      def request(method, path, payload = {}, extra_headers = {})
        case method
        when :get
          response = @connection.get(path)
        when :post
          response = @connection.post(path, JSON.generate(payload), extra_headers)
        end

        raise Gemnasium::GitlabService::InvalidApiKeyError if response.code.to_i == 401

        response_body = JSON.parse(response.body)

        if response.code.to_i / 100 == 2
          return {} if response_body.empty?
          result = response_body
        else
          if error = "#{response_body['error']}_error".split('_').collect(&:capitalize).join
            raise Gemnasium::GitlabService.const_get(error), response_body['message']
          else
            raise 'An unknown error has been returned by the server. Please contact Gemnasium support : http://support.gemnasium.com'
          end
        end
      end

    end
  end
end
