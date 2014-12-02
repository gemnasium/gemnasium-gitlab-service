require 'gemnasium/gitlab_service/errors'
require 'gemnasium/gitlab_service/pusher'

module Gemnasium
  module GitlabService
    class << self
      def execute(options)
        Pusher.new(options).call
      end
    end
  end
end
