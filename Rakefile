require "minitest/test_task"

Minitest::TestTask.create(:test) do |t|
  t.test_prelude = %(require "minitest/pride")
  t.framework = %(require_relative "./test/test_helper.rb")
  t.libs << "test"
  t.libs << "lib"
  t.warning = false
  t.test_globs = ["test/**/*_test.rb"]
end

task :default => :test
