# Ruby Default Gem Info

The **matrix** library is a default gem, which means it comes pre-installed with Ruby. Unless you need recent features, you can simply `require "matrix"` directly, no need to install it.

## Installation from rubygems.org

Ruby ships with a locked version of this gem. You can find out which version of **matrix** is included in your version of Ruby on [stdgems.org/matrix](https://stdgems.org/matrix). To get all bug fixes and the latest features you have to install this library as a gem. This can be done by adding the following line to your application's Gemfile or gem's gemspec:

```ruby
gem "matrix"
```

And then execute:

    $ bundle

To make sure the gem takes over the builtin library, run `bundle exec ...` (or call `gem 'matrix' in your code explicitly).

## Usage

See the [README](README.md) file for instructions how to use this gem.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ruby/matrix.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).
