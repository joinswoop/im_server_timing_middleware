# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'server_timing_middleware/version'

Gem::Specification.new do |spec|
  spec.name          = "server_timing_middleware"
  spec.version       = ServerTimingMiddleware::VERSION
  spec.authors       = ["Javier Honduvilla Coto", "jonathan schatz"]
  spec.email         = ["javierhonduco@gmail.com"]

  spec.summary       = %q{Rack middleware to send backend timings using the Server Timing spec.}
  spec.description   = %q{This Rack middleware uses Activesupport::Notifications to send timings to a client compliant with the Server Timing spec.}
  spec.homepage      = "https://github.com/joinswoop/server_timing_middleware"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_dependency "activesupport"
  spec.add_dependency "rack"
end
