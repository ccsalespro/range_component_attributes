# Range Component Attributes

This gem creates attributes for the lower and upper bounds of a range on an
ActiveRecord object. These attributes are automatically populated when a record
is loaded and they are written to the underlying range when a record is saved.
This makes it easier to work with ActiveRecord validations and form helpers.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'range_component_attributes'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install range_component_attributes

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

To run the tests, first run `rake db:setup`. This creates a database called `range_component_attributes_test` and load `database_structure.sql` into it.


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ccsalespro/range_component_attributes.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
