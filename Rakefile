# encoding: utf-8

require 'rubygems'
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "mspire-mascot-dat"
  gem.homepage = "http://github.com/princelab/mspire-mascot-dat"
  gem.license = "MIT"
  gem.summary = %Q{Reads mascot dat files for mspire library.}
  gem.description = %Q{Reads mascot dat files with gusto for mspire library.}
  gem.email = "jtprince@gmail.com"
  gem.authors = ["John T. Prince"]
  gem.add_dependency "elif", "~> 0.1.0"
  gem.add_development_dependency "rspec", "~> 2.8.0"
  gem.add_development_dependency "rdoc", "~> 3.12"
  gem.add_development_dependency "jeweler", "~> 1.8.4"
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

task :default => :spec

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "mspire-mascot-dat #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
