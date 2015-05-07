Gem::Specification.new do |s|
  s.name        = 'gfwlist2ipset'
  s.version     = '0.0.1'
  s.date        = '2015-05-07'
  s.summary     = "gfwlist2ipset"
  s.description = "Generate dnsmasq ipset configure file from gfwlist"
  s.authors     = ["Nullizer"]
  s.email       = 'nullizer@gmail.com'
  s.files       = ["bin/gfwlist2ipset"]
  s.homepage    = 'http://rubygems.org/gems/gfwlist2ipset'
  s.license     = 'MIT'
  s.executables << 'gfwlist2ipset'
  s.add_dependency "public_suffix"
end