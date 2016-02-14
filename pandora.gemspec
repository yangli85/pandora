# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "pandora"
  spec.version       = ENV['GEM_VERSION'] || "1.0.0"
  spec.authors       = ["yangli"]
  spec.email         = ["3217169615@qq.com"]

  spec.summary       = %q{pandora}
  spec.description   = %q{A gem for the SQL to provide CRUD operations on the DB}
  spec.homepage      = ""
  spec.license       = "MIT"

  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "http://101.200.162.121:9292"
  else
    # raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
    puts "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib","db","config"]

  spec.add_dependency 'mysql2'
  spec.add_dependency 'activerecord', '~> 4.2.0'
  spec.add_dependency 'rake', '~> 10.0'
  spec.add_dependency 'bundler', '~> 1.10'

  spec.add_development_dependency 'factory_girl'
  spec.add_development_dependency 'database_cleaner'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rspec_junit_formatter', '~> 0.2.3'
  spec.add_development_dependency 'bundler_geminabox', '0.2.0'
end
