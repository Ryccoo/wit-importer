# Wit::Importer

Currently WIT.AI does not allow any way to export, clone or share application with public only with list of allowed people.
You can export you application and let other users import it however, this can be done only when creating new app.

This **WIT IMPORTER** tool allowes you to import all definitions of expoerted app to either new or app that already contains other definitions. 

Be avare that the definitions will load alongside your previous and it can't be undone other than manually.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'wit-importer'
```
## Usage

Download the app as zip and unzip it.

SERVER_KEY: the **SERVER** key of the app you want to import it to  
PATH: path to the root of unzipped app  

``Usage: wit-importer [SERVER_KEY] [PATH_TO_APP_ZIP_ROOT]``


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/wit-importer. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Wit::Importer project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/wit-importer/blob/master/CODE_OF_CONDUCT.md).
