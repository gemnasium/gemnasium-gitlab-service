require './lib/gemnasium/gitlab_service/version'

Gem::Specification.new do |gem|
  gem.authors       = ["Tech-Angels"]
  gem.email         = ["contact@tech-angels.com"]
  gem.description   = "Gemnasium service for Gitlab"
  gem.summary       = gem.description
  gem.homepage      = "https://gemnasium.com/"
  gem.license       = 'MIT'

  gem.files         = `git ls-files`.split($\)
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "gemnasium-gitlab-service"
  gem.require_paths = ["lib"]
  gem.executables   = gem.files.grep(%r{^bin/}) { |f| File.basename(f) }
  gem.version       = Gemnasium::GitlabService::VERSION


  gem.add_runtime_dependency "gitlab_git"

  gem.add_development_dependency 'rake', '~>10.0.3'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'webmock'
end
