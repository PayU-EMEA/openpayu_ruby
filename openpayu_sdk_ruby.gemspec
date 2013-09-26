# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'openpayu/version'

Gem::Specification.new do |spec|
  spec.name          = "openpayu"
  spec.version       = OpenPayU::VERSION
  spec.authors       = ["Krzysztof Streflik"]
  spec.email         = ["krzysztof.streflik@allegro.pl"]
  spec.description   = %q{A SDK for OpenPayU API}
  spec.summary       = %q{A SDK for OpenPayU API}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "activemodel", "~> 3.2"
  spec.add_development_dependency "activesupport", "~> 3.2"  
  spec.add_runtime_dependency "activemodel", "~> 3.2"
  spec.add_runtime_dependency "activesupport", "~> 3.2"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "fakeweb"
  spec.add_development_dependency "yard"
  spec.add_development_dependency "rdoc"
end
