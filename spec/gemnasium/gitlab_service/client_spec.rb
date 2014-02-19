require 'spec_helper'

describe Gemnasium::GitlabService::Client do
  before do
    stub_requests
  end
  let(:client) { Gemnasium::GitlabService::Client.new({api_key: "secret_api_key"}) }

  describe 'initialize' do
    it 'initializes a Connection object' do
      client.instance_variable_get('@connection').should be_kind_of(Gemnasium::GitlabService::Connection)
    end
  end

  describe 'compare_sha1s' do
    before do
      @files = [{"filename_1" => "sha1_1"},{"filename_2" => "sha1_2"}]
      client.compare_sha1s('project_id', 'branch_id', @files)
    end
    it 'issues a POST request' do
      expect(WebMock).to have_requested(:post, api_url("projects/project_id/branches/branch_id/dependency_files/compare"))
        .with(:body => JSON.generate(@files), :headers => {'Accept'=>'application/json', 'Content-Type'=>'application/json'})
    end
  end

  describe 'upload_files' do
    before do
      @files = [
        {"filename" => "filename_1", "sha" => "sha_1","content" => "content_1"},
        {"filename" => "filename_2", "sha" => "sha_2","content" => "content_2"}
      ]
      client.upload_files('project_id', 'branch_id', @files)
    end
    it 'issues a POST request' do
      expect(WebMock).to have_requested(:post, api_url("projects/project_id/branches/branch_id/dependency_files/upload"))
        .with(:body => JSON.generate(@files), :headers => {'Accept'=>'application/json', 'Content-Type'=>'application/json'})
    end
  end

end
