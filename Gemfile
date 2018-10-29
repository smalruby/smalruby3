source 'https://rubygems.org'

gemspec

work_dir = ENV['SMALRUBY_WORK_DIR'] || '~/work/smalruby'

path = File.expand_path(File.join(work_dir, 'dxruby_sdl'))
if File.exist?(path)
  gem 'dxruby_sdl', path: path
end

path = File.expand_path(File.join(work_dir, 'smalrubot'))
if File.exist?(path)
  gem 'smalrubot', path: path
end
