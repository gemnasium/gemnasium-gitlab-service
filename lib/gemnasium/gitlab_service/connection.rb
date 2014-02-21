require 'net/https'

module Gemnasium
  module GitlabService
    class Connection
      DEFAULT_ENDPOINT = 'gemnasium.com'
      DEFAULT_API_VERSION = 'v3'
      DEFAULT_SSL = true
      DEFAULT_AGENT = "Gemnasium Gitlab Service - v#{Gemnasium::GitlabService::VERSION}"

      def initialize(options = {})
        use_ssl = options[:use_ssl] || DEFAULT_SSL
        host = options[:host] || DEFAULT_ENDPOINT
        port = options[:port] || (use_ssl ? 443 : 80)

        @connection = Net::HTTP.new(host, port)
        @connection.use_ssl = use_ssl
        # @connection.set_debug_output($stdout)
        @api_key = options[:api_key]
        @base_url = "/api/" + (options[:api_version] || DEFAULT_API_VERSION).to_s + "/"
      end

      def post(path, body, headers = {})
        request = Net::HTTP::Post.new(@base_url + path, headers.merge('Accept' => 'application/json', 'Content-Type' => 'application/json', 'User-Agent' => DEFAULT_AGENT))
        request.basic_auth('X', @api_key)
        request.body = body
        @connection.request(request)
      end

      def get(path, headers = {})
        request = Net::HTTP::Get.new(@base_url + path, headers.merge('Accept' => 'application/json', 'Content-Type' => 'application/json', 'User-Agent' => DEFAULT_AGENT))
        request.basic_auth('X', @api_key)
        @connection.request(request)
      end

    end
  end
end
