Gem::Specification.new do |s|
  s.name = 'maphosts'
  s.version = '0.0.1'
  s.date = '2014-12-22'
  s.summary = ''
  s.description = ''
  s.authors = ['Marc Scholten']
  s.email = 'marc@pedigital.de'
  s.homepage = 'https://www.github.com/mpscholten/hosts-manager'
  s.license = 'MIT'

  s.files = ['lib/host_manager.rb']
  s.executables << 'maphosts'

  s.add_dependency 'hosts', '~> 0.1'
  s.add_dependency 'colorize', '~> 0.7'
  s.add_development_dependency 'rspec'
end
