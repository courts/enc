# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{Enc}
  s.version = "0.0.9"
  s.authors = ["Patrick Hof"]
  s.date = %q{2012-04-27}
  s.email = %q{courts@offensivethinking.org}
  s.files = %w(README.markdown Rakefile bin/enc-cli lib/enc/dec.rb lib/enc/enc.rb test/spec_enc.rb test/spec_dec.rb)
  s.executables = ["enc-cli"]
  s.homepage = %q{http://www.offensivethinking.org}
  s.require_paths = ["lib/enc"]
  s.summary = %q{A module implementing commonly used string encoders for various occasions.}
  s.description = <<-EOF
    A module implementing commonly used string encoders for various occasions.
    It's intended primary use is to include it in your scripts. A basic command line
    client is included.
  EOF
end
