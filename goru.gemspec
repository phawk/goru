# frozen_string_literal: true

require File.expand_path("../lib/goru/version", __FILE__)

Gem::Specification.new do |spec|
  spec.name = "goru"
  spec.version = Goru::VERSION
  spec.summary = "Concurrent routines for Ruby."
  spec.description = spec.summary

  spec.author = "Bryan Powell"
  spec.email = "bryan@metabahn.com"
  spec.homepage = "https://github.com/metabahn/goru/"

  spec.required_ruby_version = ">= 2.6.7"

  spec.license = "MPL-2.0"

  spec.files = Dir["CHANGELOG.md", "README.md", "LICENSE", "lib/**/*"]
  spec.require_path = "lib"

  spec.add_dependency "core-extension", "~> 0.4"
  spec.add_dependency "core-global", "~> 0.1"
  spec.add_dependency "nio4r", "~> 2.5"
  spec.add_dependency "timers", "~> 4.3"
end
