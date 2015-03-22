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

  describe 'upload_files' do
    let(:files) do
      [
        double('Gemfile', path: 'Gemfile', sha: 'sha of Gemfile', content: 'content of Gemfile'),
        double('Gemfile.lock', path: 'Gemfile.lock', sha: 'sha of Gemfile.lock', content: 'content of Gemfile.lock'),
      ]
    end

    before do
      client.upload_files(
        files, 'project_slug',
        'branch_name', 'commit_sha'
      )
    end

    it 'issues a POST request' do
      expected_payload = JSON.generate [
        {
          'path' => 'Gemfile',
          'sha' => 'sha of Gemfile',
          'content' => "Y29udGVudCBvZiBHZW1maWxl\n",
        },
        {
          'path' => 'Gemfile.lock',
          'sha' => 'sha of Gemfile.lock',
          'content' => "Y29udGVudCBvZiBHZW1maWxlLmxvY2s=\n",
        },
      ]

      expect(WebMock).to have_requested(:post, api_url("projects/project_slug/dependency_files")).
        with(
          :body => expected_payload,
          :headers => {
            'Accept'=>'application/json',
            'Content-Type'=>'application/json',
            'X-Gms-Branch'=> 'branch_name',
            'X-Gms-Revision'=> 'commit_sha',
          }
      )
    end
  end

end
