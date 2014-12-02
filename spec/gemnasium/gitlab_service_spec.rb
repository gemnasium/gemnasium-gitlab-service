require 'spec_helper'

describe Gemnasium::GitlabService do

  describe 'execute' do
    let(:options) do
      {
        token: "project_token",
        ref: "refs/heads/master",
        repo: 'ignore',
        after: 'ignore'
      }
    end

    let(:client) { double(:client).as_null_object }
    let(:dependency_files) { [] }

    before do
      Rugged::Repository.stub :new
      Gemnasium::GitlabService::Client.stub(:new).and_return(client)
      Gemnasium::GitlabService::Pusher.any_instance.stub(:dependency_files).and_return(dependency_files)
    end

    context "when there's no dependency file" do
      let(:dependency_file) { [] }

      it 'does nothing' do
        expect(client).not_to receive(:upload_files)
        Gemnasium::GitlabService.execute options
      end
    end

    context "when repo has dependency files" do
      let(:dependency_file) do
        [{ "filename" => "Gemfile", "sha" => "sha1", "content" => "some content"}]
      end

      it 'send them to gemnasium.com' do
        expect(client).not_to receive(:upload_files).
          with('project_token', 'master', dependency_files)
        Gemnasium::GitlabService.execute options
      end
    end
  end
end
