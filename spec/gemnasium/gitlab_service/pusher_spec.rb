require 'spec_helper'
require 'tmpdir'

# Pusher integration test: it relies on Rugged and loads an existing git repo.
# The client is stubbed (or mocked) and there's no network connection.
#
describe Gemnasium::GitlabService::Pusher do
  let(:client) { double('client').stub(:upload_files) }

  let(:options) do
    {
      repo: repo_path,
      after: commit_sha,
      ref: 'refs/heads/dev',
      token: 'gemnasium-user/the-project',
      client: client
    }
  end

  let(:pusher) { described_class.new(options) }

  let(:gemfile_content) do
    <<-EOS
source 'https://rubygems.org'
gem 'jasmine'
gem 'juicer'
gem 'json'
    EOS
  end

  let(:lockfile_content) do
    <<-EOS
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
  end

  let(:repo_path) { Dir.mktmpdir }

  let(:commit_sha) do
    repo = Rugged::Repository.init_at(repo_path)
    index = repo.index

    repo.write(gemfile_content, :blob).tap do |oid|
      index.add(path: "depfiles/Gemfile", :oid => oid, :mode => 0100644)
    end

    repo.write(lockfile_content, :blob).tap do |oid|
      index.add(path: "depfiles/Gemfile.lock", :oid => oid, :mode => 0100644)
    end

    options = {}
    options[:tree] = index.write_tree(repo)
    options[:author] = { :email => "fcat@github.com", :name => 'Fabien Catteau', :time => Time.now }
    options[:committer] = { :email => "fcat@github.com", :name => 'Fabien Catteau', :time => Time.now }
    options[:message] ||= "Add some Ruby dependency files"
    options[:parents] = []
    options[:update_ref] = 'HEAD'

    Rugged::Commit.create(repo, options).to_s
  end

  after do
    FileUtils.rm_rf repo_path
  end

  describe "#call" do
    it "pushes the dependency files" do
      file_class = described_class::DependencyFile

      expect(client).to receive(:upload_files).with(
        [
          file_class.new('depfiles/Gemfile', "68609d16b77711fd079668539a07a648fe837c84", gemfile_content),
          file_class.new('depfiles/Gemfile.lock', "c6d0eedc76b94d6412a9ab9741a10782116c1c47", lockfile_content),
        ],
        project_slug: 'gemnasium-user/the-project',
        branch_name: 'dev',
        commit_sha: commit_sha,
      )
      pusher.call
    end
  end

end
