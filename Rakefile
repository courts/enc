require 'yard'
require 'rake/clean'

CLEAN.include('doc/', '*.gem')

task :buildgem do
  puts `gem build Enc.gemspec`
end

task :install => [:clean, :buildgem] do
  puts `gem install Enc-*.gem`
end

YARD::Rake::YardocTask.new do |t|
  t.files   = ['lib/enc/enc.rb', 'lib/enc/dec.rb']
  t.options = ['--main', 'README.markdown']
end
