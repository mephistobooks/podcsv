# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'podcsv/version'

Gem::Specification.new do |spec|
  spec.name          = "podcsv"
  spec.version       = PodCSV::VERSION
  spec.authors       = ["YAMAMOTO, Masayuki"]
  spec.email         = ["martin.route66.blues+github@gmail.com"]

  spec.summary       = %q{Parse-on-demand CSV.}
  spec.description   = %q{This gem defines PodCSV and PodArray which are available to cache and parse data on-demand. These are useful when you need to read a big CSV file (around thousand records) but use very small part of it.}
  spec.homepage      = "TODO: Put your gem's website or public repo URL here."
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
