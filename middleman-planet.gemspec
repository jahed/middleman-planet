# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "middleman-planet"
  s.version     = "0.0.1"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jahed Ahmed"]
  s.email       = ["jahed.public@gmail.com"]
  s.homepage    = "http://github.com/jahed/middleman-planet"
  s.summary     = %q{Feed Aggregator Extension for Middleman}
  s.description = %q{Feed Aggregator Extension for Middleman. Insprited by Planet.}
  s.license     = "MIT"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency("middleman-core", "~> 3.3")
  s.add_runtime_dependency("feedjira", "~> 1.6")
  s.add_runtime_dependency("colorize")
end
