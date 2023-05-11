# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |s|
  s.name        = 'ddtrace-method-wrapper'
  s.version     = '2.0.0'
  s.authors     = ["Brandfolder, Inc."]
  s.email       = 'developers@brandfolder.com'
  s.files       = Dir['{lib/**/*,[A-Z]*}']
  s.homepage    = 'https://github.com/brandfolder/ddtrace-rb-method-wrapper'
  s.license     = 'MIT'

  s.summary     = "Datadog.tracer.trace lib wrapper"
  s.description = <<-EOS.gsub(/^[\s]+/, '')
    `ddtrace-method-wrapper` adds convenience methods to Datadog's ruby tracing library `ddtrace`.
    Extend your classes and modules and wrap their methods with custom datadog tracing.
  EOS

  if s.respond_to?(:metadata)
    s.metadata['allowed_push_host'] = 'https://rubygems.org'
  else
    raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  s.add_dependency 'ddtrace'

  # Development Dependencies
  s.add_development_dependency 'rubocop', '= 0.49.1' if RUBY_VERSION >= '2.1.0'
  s.add_development_dependency 'rspec', '~> 3.0'
end
