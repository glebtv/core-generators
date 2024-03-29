# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "core/version"

Gem::Specification.new do |s|
  s.name        = "core-generators"
  s.version     = Core::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["lucasefe"]
  s.email       = ["lucasefe@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{core generators used by me}
  s.description = %q{core generators used by me}

  s.rubyforge_project = "core-generators"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
