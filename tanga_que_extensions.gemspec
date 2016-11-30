$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "tanga_que_extensions"
  s.version     = "0.0.18"
  s.authors     = ["Joe Van Dyk"]
  s.email       = ["joe@tanga.com"]
  s.homepage    = "https://www.tanga.com"
  s.summary     = "job scheduling stuff for tanga"
  s.require_paths = ["lib"]
  s.files = Dir["lib/**/*.rb"]
  s.test_files = Dir["test/**/*"]
  s.add_dependency 'que', '0.11.5'
  s.add_dependency 'activerecord', '> 0'
  s.add_dependency 'pg', '> 0'
  s.add_dependency 'dino_utils', '>= 0.1.16'
  s.add_dependency 'airbrake', '>= 0'
end
