def api_url(path)
  "https://X:secret_api_key@gemnasium.com/api/v3/#{path}"
end

def stub_requests
  request_headers = {'Accept'=>'application/json', 'Content-Type'=>'application/json'}
  response_headers = {'Content-Type'=>'application/json'}

  # Push requests
  stub_request(:post, api_url("projects/project_id/branches/branch_id/dependency_files/compare"))
           .to_return(:status => 200,
                      :body => '{ "to_upload": [], "deleted": [] }',
                      :headers => response_headers)

  stub_request(:post, api_url("projects/project_id/branches/branch_id/dependency_files/upload"))
           .to_return(:status => 200,
                      :body => '{ "added": ["new_gemspec.gemspec"], "updated": ["modified_lockfile.lockfile"], "unchanged": [], "unsupported": [] }',
                      :headers => response_headers)

  # Connection model's test requests
  stub_request(:get, api_url('test_path'))
          .with(:headers => request_headers)

  stub_request(:post, api_url('test_path'))
          .with(:body => {"foo"=>"bar"}, :headers => request_headers)
end
