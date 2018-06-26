
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "range_component_attributes/version"

Gem::Specification.new do |spec|
  spec.name          = "range_component_attributes"
  spec.version       = RangeComponentAttributes::VERSION
  spec.authors       = ["Jack Christensen"]
  spec.email         = ["jack@jackchristensen.com"]

  spec.summary       = %q{Splits database ranges into lower and upper attributes in ActiveRecord}
  spec.homepage      = "https://github.com/ccsalespro/range_component_attributes"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'activerecord', ">= 5.2.0"
  spec.add_dependency 'activesupport', ">= 5.2.0"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "minitest-reporters"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency 'pg', "~> 1.0"
  spec.add_development_dependency 'pry'
end
