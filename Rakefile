require 'yard'
require 'rake/clean'

CLEAN.include('doc/', '*.gem')

YARD::Rake::YardocTask.new do |t|
  t.files   = ['lib/enc.rb', 'lib/dec.rb']
  t.options = ['--main', 'README.markdown']
end
