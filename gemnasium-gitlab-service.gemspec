require './lib/gemnasium/gitlab_service/version'

Gem::Specification.new do |gem|
  gem.authors       = ["Tech-Angels"]
  gem.email         = ["contact@tech-angels.com"]
  gem.description   = "Add Gemnasium support to Gitlab as a Project Service.
    It uploads the dependency files to https://api.gemnasium.com
    whenever a new commit is pushed to your repository."

  gem.summary       = "Gemnasium service for Gitlab"
  gem.homepage      = "https://github.com/gemnasium/gemnasium-gitlab-service"
  gem.license       = 'MIT'
  gem.files         = `git ls-files`.split($\)
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "gemnasium-gitlab-service"
  gem.require_paths = ["lib"]
  gem.executables   = gem.files.grep(%r{^bin/}) { |f| File.basename(f) }
  gem.version       = Gemnasium::GitlabService::VERSION

  gem.add_runtime_dependency "rugged", '~> 0.19'

  gem.add_development_dependency 'rake', '~> 10.0'
  gem.add_development_dependency 'rspec', '~> 2.14'
  gem.add_development_dependency 'webmock', '~> 1.17'
end
