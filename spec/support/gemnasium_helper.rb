def api_url(path)
  "https://api.gemnasium.com/v1/#{path}"
end

def stub_requests
  request_headers = {
    'Accept'=>'application/json',
    'Content-Type'=>'application/json',
    'User-Agent' => "Gemnasium Gitlab Service - v#{Gemnasium::GitlabService::VERSION}"
  }
  response_headers = {'Content-Type'=>'application/json'}

  stub_request(:post, api_url("projects/project_slug/dependency_files"))
    .with(:headers => request_headers)
    .to_return(:status => 200,
      :body => '{ "added": ["new_gemspec.gemspec"], "updated": ["modified_lockfile.lockfile"], "unchanged": [], "unsupported": [] }',
      :headers => response_headers)

  # Connection model's test requests
  stub_request(:get, api_url('test_path'))
    .with(:headers => request_headers)

  stub_request(:post, api_url('test_path'))
    .with(:body => {"foo"=>"bar"}, :headers => request_headers)
end
