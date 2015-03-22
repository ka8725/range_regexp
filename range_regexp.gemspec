# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'range_regexp/version'

Gem::Specification.new do |spec|
  spec.name          = "range_regexp"
  spec.version       = RangeRegexp::VERSION
  spec.authors       = ["Andrey Koleshko"]
  spec.email         = ["ka8725@gmail.com"]
  spec.summary       = %q{Convert a Ruby range to a regexp.}
  spec.description   = %q{The solution to convert a Ruby range to a regexp.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
