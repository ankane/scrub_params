require "bundler/gem_tasks"
require "rake/testtask"

task :default => :test
Rake::TestTask.new do |t|
  t.libs << "test"
  t.pattern = "test/**/*_test.rb"
end

task :benchmark do
  require "bundler/setup"
  Bundler.require(:default)

  list = []
  1000.times do
    params = ActionController::Parameters.new
    100.times do |i|
      params[i] = "Hello <script>alert('World')</script>"
    end
    list << params
  end

  Benchmark.bm do |bm|
    bm.report do
      list.each do |params|
        params.scrub!
      end
    end
  end
end
