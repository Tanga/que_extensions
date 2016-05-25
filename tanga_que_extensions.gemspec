$:.push File.expand_path("../lib", __FILE__)

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "tanga_que_extensions"
  s.version     = "0.0.1"
  s.authors     = ["Peter van Wesep"]
  s.email       = ["tanga.web.consultant@gmail.com"]
  s.homepage    = "https://www.tanga.com"
  s.summary     = "job scheduling stuff for tanga"
  s.require_paths = ["lib"]
  #s.files = Dir["lib/periodic_job.rb"]
  s.test_files = Dir["test/**/*"]
  s.add_dependency 'que', '0.9.0'
end
