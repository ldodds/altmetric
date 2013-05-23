PKG_FILES = %w( README.md Rakefile ) + 
  Dir.glob("{bin,test,lib}/**/*")

RDOC_OPTS = ['--quiet', '--title', 'Altmetric Client', '--main', 'README.md']

Gem::Specification.new do |s|
  s.name = "altmetric.rb"
  s.version = "0.0.2"
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = ">= 1.9.3"    
  s.has_rdoc = true
  s.extra_rdoc_files = ["README.md"]
  s.rdoc_options = RDOC_OPTS
  s.summary = "Altmetric API Client"
  s.description = s.summary
  s.author = "Leigh Dodds"
  s.email = 'leigh@ldodds.com'
  s.homepage = 'http://github.com/ldodds/altmetric'
  s.files = PKG_FILES
  s.require_path = "lib" 
  s.bindir = "bin"
  s.test_file = "tests/ts_altmetric.rb"
  s.add_dependency("json")
  s.add_dependency("httpclient")
  s.add_dependency("uri_template")
end
