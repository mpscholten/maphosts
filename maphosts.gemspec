Gem::Specification.new do |s|
  s.name = 'maphosts'
  s.version = '1.1.1'
  s.date = '2015-06-23'
  s.summary = 'Keeps your project hostnames in sync with /etc/hosts'
  s.description = 'Small command line application for keeping your project hostnames in sync with /etc/hosts'
  s.authors = ['Marc Scholten']
  s.email = 'marc@pedigital.de'
  s.homepage = 'https://github.com/mpscholten/maphosts'
  s.license = 'MIT'

  s.files = ['lib/maphosts/host_manager.rb']
  s.executables << 'maphosts'

  s.required_ruby_version = '~> 2.0'
  s.add_dependency 'hosts', '~> 0.1'
  s.add_dependency 'colorize', '~> 0.7'
  s.add_development_dependency 'rspec'
end
