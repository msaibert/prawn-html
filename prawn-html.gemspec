# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'prawn/html/version'

Gem::Specification.new do |spec|
  spec.name          = "prawn-html"
  spec.version       = Prawn::Html::VERSION
  spec.authors       = ["Marlon"]
  spec.email         = ["marlonsaibert@gmail.com"]
  spec.description   = %{A gem to convert html in prawn code}
  spec.summary       = ""
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'prawn', '~> 1.2.1'
  spec.add_development_dependency 'prawn-table'
  spec.add_development_dependency 'nokogiri'
  spec.add_development_dependency 'rspec'
end
