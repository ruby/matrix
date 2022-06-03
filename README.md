# Matrix [![Version](https://badge.fury.io/rb/matrix.svg)](https://badge.fury.io/rb/matrix) [![Bundled Gem](https://img.shields.io/badge/stdgem-bundled-9c1260.svg)](https://stdgems.org/matrix/)  [![Test](https://github.com/ruby/matrix/workflows/test/badge.svg)](https://github.com/ruby/matrix/actions?query=workflow%3Atest)

An implementation of `Matrix` and `Vector` classes.

The `Matrix` class represents a mathematical matrix. It provides methods for creating matrices, operating on them arithmetically and algebraically, and determining their mathematical properties (trace, rank, inverse, determinant, eigensystem, etc.).

The `Vector` class represents a mathematical vector, which is useful in its own right, and also constitutes a row or column of a `Matrix`.

## Installation

The `matrix` library comes pre-installed with Ruby. Unless you need recent features, you can simply `require 'matrix'` directly, no need to install it.

If you need features that are more recent than the version of Ruby you want to support (check the [CHANGELOG](CHANGELOG.md)), you must use the gem. To do this, add this line to your application's Gemfile or gem's gemspec:

```ruby
gem 'matrix'
```

And then execute:

    $ bundle

To make sure that the gem takes precedence over the builtin library, call `bundle exec ...` (or call `gem 'matrix'` explicitly).

## Usage

```ruby
require 'matrix'
m = Matrix[[1, 2], [3, 4]]
m.determinant # => -2
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ruby/matrix.

## License

The gem is available as open source under the terms of the [2-Clause BSD License](https://opensource.org/licenses/BSD-2-Clause).
