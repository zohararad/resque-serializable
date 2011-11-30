# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "resque-serializable/version"

Gem::Specification.new do |s|
  s.name        = "resque-serializable"
  s.version     = Resque::Serializable::VERSION
  s.authors     = ["Zohar Arad"]
  s.email       = ["zohar@zohararad.com"]
  s.homepage    = ""
  s.summary     = %q{Serialize & Unserialize Resque job arguments}
  s.description = %q{Adds support for serializable arguments in a Resque job. Serializable arguments can be passed to a Resque job via a Hash containing a :serialize key. If such arguments are found, they will be deserialized before calling the job's perform method}

  s.rubyforge_project = "resque-serializable"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "resque", "~>1.19.0"
end
