# Transform Ruby ranges to regexps

The solution to convert a numeric Ruby `Range` to a `Regexp`

# Install

In the system:

`gem install range_regexp`

or add the gem to the `Gemfile`:

`gem 'range_regexp'`

and then run `bundle install`.

# Usage

```ruby
converter = RangeRegexp::Converter.new(-9..9)
converter.convert # => /-[1-9]|\d/
```
