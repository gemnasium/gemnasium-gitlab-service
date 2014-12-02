require 'spec_helper'

# Pusher integration test: it relies on Rugged and loads an existing git repo.
# The client is stubbed (or mocked) and there's no network connection.
#
describe Gemnasium::GitlabService::Pusher do
  let(:client) { double('client').stub(:upload_files) }
  let(:repo_path) { File.expand_path('../../../fixtures/repo', __FILE__) }

  let(:options) do
    {
      repo: repo_path,
      after: '9da08d77df2a30a5b578aaa482cce11bf6d4297c',
      ref: 'refs/heads/devel',
      token: 'gemnasium-user/the-project',
      client: client
    }
  end

  let(:pusher) { described_class.new(options) }

  describe "#call" do
    it "pushes the dependency files" do
      expect(client).to receive(:upload_files).with(
        'gemnasium-user/the-project', '9da08d77df2a30a5b578aaa482cce11bf6d4297c', [
          described_class::DependencyFile.new('depfiles/Gemfile', "68609d16b77711fd079668539a07a648fe837c84", <<-EOS),
source 'https://rubygems.org'
gem 'jasmine'
gem 'juicer'
gem 'json'
            EOS
          described_class::DependencyFile.new('depfiles/Gemfile.lock', "c6d0eedc76b94d6412a9ab9741a10782116c1c47", <<-EOS),
GEM
  remote: https://rubygems.org/
  specs:
    addressable (2.3.2)
    childprocess (0.3.5)
      ffi (~> 1.0, >= 1.0.6)
    diff-lcs (1.1.3)
    ffi (1.1.5)
    jasmine (1.2.1)
      jasmine-core (>= 1.2.0)
      rack (~> 1.0)
      rspec (>= 1.3.1)
      selenium-webdriver (>= 0.1.3)
    jasmine-core (1.2.0)
    json (1.7.5)
    libwebsocket (0.1.5)
      addressable
    multi_json (1.3.6)
    rack (1.4.1)
    rspec (2.11.0)
      rspec-core (~> 2.11.0)
      rspec-expectations (~> 2.11.0)
      rspec-mocks (~> 2.11.0)
    rspec-core (2.11.1)
    rspec-expectations (2.11.3)
      diff-lcs (~> 1.1.3)
    rspec-mocks (2.11.2)
    rubyzip (0.9.9)
    selenium-webdriver (2.25.0)
      childprocess (>= 0.2.5)
      libwebsocket (~> 0.1.3)
      multi_json (~> 1.0)
      rubyzip

PLATFORMS
  ruby

DEPENDENCIES
  jasmine
  json
            EOS
        ]
      )
      pusher.call
    end
  end

end
