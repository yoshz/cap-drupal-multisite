# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |spec|
  spec.name        = "cap-drupal-multisite"
  spec.version     = "0.2.0"
  spec.authors     = ["Yosh de Vos"]
  spec.email       = ["yosh@elzorro.nl"]
  spec.homepage    = "https://github.com/yoshz/cap-drupal-multisite"
  spec.summary     = "A collection of capistrano tasks for deploying drupal sites"
  spec.description = "A collection of capistrano tasks for deploying drupal sites"
  spec.license     = 'MIT'

  spec.files         = `git ls-files`.split("\n")
  spec.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  spec.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "capistrano", ">= 3.2.1"
  spec.add_dependency "sshkit", ">= 1.4.0"
  spec.add_dependency "colorize"
  spec.add_dependency "highline"
end
