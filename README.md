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

Gitlab currently doesn't provide the Gemnasium Service out of the box, you can check and support our [pull request](https://github.com/gitlabhq/gitlabhq/pull/6372) to make it part of master.

In the mean time, if you want to add Gemnasium service to your own instance of Gitlab, it's quite easy.

We provide dedicated branches for [6-5-stable](https://github.com/gemnasium/gitlabhq/tree/add_gemnasium_service_on_6-5-stable) and [6-6-stable](https://github.com/gemnasium/gitlabhq/tree/add_gemnasium_service_on_6-6-stable) releases of Gitlab.

You just have to :

* checkout the branch
* migrate the schema
* bundle
* restart gitlab

And here you go, Gemnasium should now be available in the project's services list.

To set up your service, you need to grab your Gemnasium API KEY and the project's token on [gemnasium.com](https://gemnasium.com)

## Troubleshooting

If you're encountering issues, feel free to contact [Gemnasium support](http://support.gemnasium.com).

## Contributing

1. Fork the project.
2. Make your feature or bug fix.
3. Test it.
4. Commit.
5. Create new pull request.
