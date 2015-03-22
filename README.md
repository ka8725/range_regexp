# Transform Ruby ranges to regexps

The solution to convert a Ruby `Range` to a `Regexp`

# Install

In the system:

`gem install range-regexp`

or add the gem to the `Gemfile`:

`gem 'range-regexp'`

and then run `bundle install`.

# Usage

```ruby
converter = RangeRegexp::Converter.new(-9..9)
converter.convert # => /-[1-9]|\d/
```
