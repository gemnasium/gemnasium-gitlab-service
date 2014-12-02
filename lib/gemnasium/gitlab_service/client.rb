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
      #         branch [String] Identifier of the branch
      #         files [Hash] files to be uploaded. Eg:
      #           [
      #             {
      #               "filename"  : "dependency_filename",
      #               "sha"       : "new_sha",
      #               "content"   : "new_content"
      #             },
      #             ...
      #           ]
      def upload_files(project, branch, files)
        request(:post, "projects/#{project}/branches/#{branch}/dependency_files/upload", files)
      end

      private

      # Issue a HTTP request
      #
      # @params method [String] Method of the request
      #         path [String] Path of the request
      #         parameters [Hash] Parameters to send a POST request
      def request(method, path, parameters = {})
        case method
        when :get
          response = @connection.get(path)
        when :post
          response = @connection.post(path, JSON.generate(parameters))
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
