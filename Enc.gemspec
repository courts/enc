# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{Enc}
  s.version = "0.0.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Patrick Hof"]
  s.date = %q{2010-04-10}
  s.email = %q{courts@offensivethinking.org}
  s.files = ["README.markdown", "Rakefile", "bin/enc-cli", "bin/dec-cli", "lib/dec.rb", "lib/enc.rb", "test/spec_enc.rb", "test/spec_dec.rb"]
  s.executables = ["enc-cli", "dec-cli"]
  s.homepage = %q{http://www.offensivethinking.org}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{A module implementing commonly used string encoders for various occasions.}
  s.description = <<-EOF
    A module implementing commonly used string encoders for various occasions.
    It's intended primary use is to include it in your scripts. A basic command line
    client is included.
  EOF

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
