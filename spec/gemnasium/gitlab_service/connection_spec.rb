require 'spec_helper'

describe Gemnasium::GitlabService::Connection do
  before do
    stub_requests
  end
  let(:connection) { Gemnasium::GitlabService::Connection.new({api_key: "secret_api_key"}) }

  describe 'initialize' do
    it 'initializes a Net::HTTP object' do
      connection.instance_variable_get('@connection').should be_kind_of(Net::HTTP)
    end
  end

  describe 'get' do
    before { connection.get('test_path') }

    it 'issues a GET request' do
      expect(WebMock).to have_requested(:get, api_url('test_path'))
                .with(:headers => {'Accept'=>'application/json', 'Content-Type'=>'application/json'})
    end
  end

  describe 'post' do
    before { connection.post('test_path', { foo: 'bar' }.to_json) }

    it 'issues a POST request' do
      expect(WebMock).to have_requested(:post, api_url('test_path'))
                .with(:body => {"foo"=>"bar"}, :headers => {'Accept'=>'application/json', 'Content-Type'=>'application/json'})
    end
  end

end
