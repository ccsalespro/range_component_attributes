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

Include `RangeComponentAttributes` module in classes you want to work with range
components. You can include it in `ActiveRecord::Base` or `ApplicationRecord` if
you want it available in all models.

Use class method `range_component_attributes` to create range component attributes.

```ruby
class Widget < ActiveRecord::Base
  include RangeComponentAttributes

  range_component_attributes :valid_dates,
    lower_name: :valid_from,
    upper_name: :valid_to,
    type_converter: DateConverter.new,
    crossed_bounds_message: "must be less than valid to"

  range_component_attributes :valid_prices,
    lower_name: :min_price,
    upper_name: :max_price,
    lower_type_converter: DecimalConverter.new,
    upper_type_converter: DecimalConverter.new(blank_value: Float::INFINITY)
end
```

range_component_attributes creates attributes corresponding to the lower and
upper bounds of `range_name`. `lower_name` and `upper_name` controls the names
of these attributes.

`type_converter` is a callable object that converts its argument to the proper
type. There are builtin type converters `IntegerConverter`, `DecimalConverter`,
`FloatConverter`, and `DateConverter`.

In addition, `lower_type_converter` and `upper_type_converter` can be separately
specified. This is especially useful when the attributeould behave differently
for blank values. For example, the upper bound mant to consider a blank value as
Float::INFINITY.

`exclude_end` controls whether the end is exclusive or not. Ranges are
automatically normalized to this type. This is useful because PostgreSQL
automatically normalizes ranges of discrete values to exclusive endsg. `[1, 10]`
becomes `[1,11)`. RangeComponentAttributes will handle this so the exact bound
values persist even when PostgreSQL has changed them.

Validations are automatically added that create an error if an assignment to
bounds attribute fails due to a type conversion error. In addition, a validation
checks that the lower bound is less than the upper bound. This error message can
be customized by supplying `crossed_bounds_message`.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`rake test` to run the tests. You can also run `bin/console` for an interactive
prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push
git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

To run the tests, first run `rake db:setup`. This creates a database called
`range_component_attributes_test` and load `database_structure.sql` into it.
Then run `rake`.


## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/ccsalespro/range_component_attributes.

## License

The gem is available as open source under the terms of the [MIT
License](https://opensource.org/licenses/MIT).
