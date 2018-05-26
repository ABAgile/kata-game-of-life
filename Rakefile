# frozen_string_literal: true

require 'rake/testtask'

task default: :check

Rake::TestTask.new do |t|
  t.warning = true
  t.verbose = false
  t.test_files = FileList['test/*_test.rb']
end

desc 'coding style/matrix check'
task :check do
  system('bundle exec rubocop')
  system('bundle exec reek')
  system('bundle exec flog lib/')
end
