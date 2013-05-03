# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rollin/version'

Gem::Specification.new do |spec|
  spec.name          = "rollin"
  spec.version       = Rollin::VERSION
  spec.authors       = ["marano"]
  spec.email         = ["thiagomarano@gmail.com"]
  spec.description   = %q{}
  spec.summary       = %q{A Ruby minimalistic blog engine ... WATTT!!?!??}
  spec.homepage      = "http://github.com/marano/rollin"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "version"

  spec.add_dependency "redcarpet"
end
