require "bundler/gem_helper"
require "yard"
require "rspec/core/rake_task"

YARD::Rake::YardocTask.new do |t|
  t.files   = ["lib/**/*.rb"]
  t.options = []
end

if /darwin/ =~ RUBY_PLATFORM
  task :spec do
    sh "rsdl -S rspec #{ENV["SPEC_OPTS"]} #{ENV["SPEC"]}"
  end

  task :guard do
    rspec_path = "spec/rspec"
    File.open(rspec_path, "w") do |f|
      f.write(<<~EOS)
        #!/bin/sh
        bundle exec rsdl -S rspec $@
      EOS
    end
    chmod(0o755, rspec_path)
    begin
      sh "bundle exec guard"
    ensure
      rm_rf(rspec_path)
    end
  end
else
  RSpec::Core::RakeTask.new(:spec)
  task :guard do
    sh "bundle exec guard"
  end
end

task :rubocop do
  files = `git ls-files | grep -e ".rb$" | grep -v "^samples/"`
  sh "rubocop #{files.split(/\s+/m).join(" ")}"
end

namespace :gem do
  Bundler::GemHelper.install_tasks
end

task :build do
  ENV["GEM_PLATFORM"] = "linux"
  Rake::Task["gem:build"].invoke

  require "smalruby3/version"
  Bundler.with_clean_env do
    ENV["GEM_PLATFORM"] = "x86-mingw32"
    dest = "smalruby3-#{Smalruby3::VERSION}-#{ENV["GEM_PLATFORM"]}.gem"
    sh "gem build smalruby3.gemspec && mv #{dest} pkg/"
  end
end

task :release do
  ENV["GEM_PLATFORM"] = "linux"
  Rake::Task["gem:release"].invoke

  require "smalruby3/version"
  Bundler.with_clean_env do
    ENV["GEM_PLATFORM"] = "x86-mingw32"
    dest = "smalruby3-#{Smalruby3::VERSION}-#{ENV["GEM_PLATFORM"]}.gem"
    sh "gem build smalruby3.gemspec && mv #{dest} pkg/ && gem push pkg/#{dest}"
  end

  next_version = Smalruby3::VERSION.split(".").tap { |versions|
    versions[-1] = (versions[-1].to_i + 1).to_s
  }.join(".")
  File.open("lib/smalruby3/version.rb", "r+") do |f|
    lines = []
    while (line = f.gets)
      if /(\s*VERSION =\s*)/.match(line)
        line = "#{$1}\"#{next_version}\"\n"
      end
      lines << line
    end
    f.rewind
    f.write(lines.join)
  end
  sh "git add lib/smalruby3/version.rb"
  sh "git commit -m #{next_version}"
  sh "git push"
end

task default: [:rubocop, :spec]
