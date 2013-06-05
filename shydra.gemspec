# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'shydra/version'

Gem::Specification.new do |spec|
  spec.name          = "shydra"
  spec.version       = Shydra::VERSION
  spec.authors       = ["Michael Johnston"]
  spec.email         = ["lastobelus@mac.com"]
  spec.description   = %q{A fast, parallel shopify api client using typhoeus/hydra. Attempts to balance being a good citizen about api limits and fetching multiple apai records in parallel. }
  spec.summary       = %q{A fast, parallel shopify api client using typhoeus/hydraa}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]


  spec.add_runtime_dependency "typhoeus", ">= 0.6.3"
  spec.add_runtime_dependency "shopify_api", ">= 3.0.3"
  spec.add_development_dependency "bundler", ">= 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
