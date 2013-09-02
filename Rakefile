require 'rake/testtask'

task 'default' => ["test"]

Rake::TestTask.new do |t|
  #t.libs << "lib/test"
  t.test_files = FileList['test_*.rb']
  #t.verbose = false
  #t.verbose = true
  #t.warning = true
end


