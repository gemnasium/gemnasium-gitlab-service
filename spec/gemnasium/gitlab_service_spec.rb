require 'spec_helper'

describe Gemnasium::GitlabService do

  describe 'execute' do
    before do
      @options = {token: "project_token", ref: "refs/heads/master"}
      Rugged::Repository.stub :new
      @client = double(:client).as_null_object
      Gemnasium::GitlabService::Client.stub(:new).and_return(@client)
    end

    it 'grabs sha1s for supported files' do
      Gemnasium::GitlabService.should_receive(:get_sha1s).and_return({"Gemfile" => "sha1"})
      Gemnasium::GitlabService.execute @options
    end

    it 'compare them with those on gemnasium.com' do
      Gemnasium::GitlabService.stub(:get_sha1s).and_return({"Gemfile" => "sha1"})
      @client.should_receive(:compare_sha1s).with("project_token", "master", {"Gemfile" => "sha1"})
      Gemnasium::GitlabService.execute @options
    end

    context 'when no files have to be uploaded' do
      before do
        Gemnasium::GitlabService.stub(:get_sha1s).and_return({"Gemfile" => "sha1"})
        @client.stub(:compare_sha1s).and_return({"to_upload" => []})
      end

      it 'does nothing' do
        Gemnasium::GitlabService.should_not_receive(:get_files_content)
        Gemnasium::GitlabService.execute @options
      end
    end

    context 'when files have to be uploaded' do
      before do
        Gemnasium::GitlabService.stub(:get_sha1s).and_return({"Gemfile" => "sha1"})
        @client.stub(:compare_sha1s).and_return({"to_upload" => ["Gemfile"]})
        @stubbed_files = [{"filename" => "Gemfile", "sha" => "sha1", "content" => "some content"}]
      end

      it 'grabs content for these files' do
        Gemnasium::GitlabService.should_receive(:get_files_content).and_return(@stubbed_files)
        Gemnasium::GitlabService.execute @options
      end

      it 'send them to gemnasium.com' do
        Gemnasium::GitlabService.stub(:get_files_content).and_return(@stubbed_files)
        @client.should_receive(:upload_files).with("project_token", "master", @stubbed_files)
        Gemnasium::GitlabService.execute @options
      end
    end
  end
end
