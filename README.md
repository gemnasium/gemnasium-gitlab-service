# Gemnasium Gitlab Service
[![Dependency Status](https://gemnasium.com/gemnasium/gemnasium-gitlab-service.png)](https://gemnasium.com/gemnasium/gemnasium-gitlab-service)
[![Build Status](https://travis-ci.org/gemnasium/gemnasium-gitlab-service.png?branch=master)](https://travis-ci.org/gemnasium/gemnasium-gitlab-service)

This gem integrates with Gitlab's project services to automatically push your dependency files to [Gemnasium](https://gemnasium.com/) to track your project's dependencies and get notified about updates and security advisories.

Supported dependency files are:

* Ruby: `Gemfile`, `Gemfile.lock` and `*.gemspec`
* NPM: `package.json` and `npm-shrinkwrap.json`
* Pyton: `requirements.txt`, `setup.py` and `requires.txt`
* PHP Composer: `composer.json` and `composer.lock`

## Install

Gitlab provides the Gemnasium service out of the box.
Just go to your project settings, under the "Services" section, and enable "Gemnasium"".
To set up your service, you need to grab your [Gemnasium API KEY](https://gemnasium.com/settings) and the project's token on [gemnasium.com](https://gemnasium.com)

## Troubleshooting

If you encounter any issue, please contact [Gemnasium support](http://support.gemnasium.com).

## Contributing

1. Fork the project.
2. Make your feature or bug fix.
3. Test it.
4. Commit.
5. Create new pull request.
