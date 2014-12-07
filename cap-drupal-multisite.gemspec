# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "cap-drupal-multisite"
  s.version     = "0.1.0"
  s.authors     = ["Yosh de Vos"]
  s.email       = ["yosh@elzorro.nl"]
  s.homepage    = "https://github.com/yoshz/cap-drupal-multisite"
  s.summary     = "A collection of capistrano tasks for deploying drupal sites"
  s.description = "A collection of capistrano tasks for deploying drupal sites"
  s.license     = 'MIT'
  #s.rubyforge_project = "capistrano-drupal"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency "capistrano", ">= 3.0.0"
end
