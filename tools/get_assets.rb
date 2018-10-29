#!/usr/bin/env ruby

require "open-uri"
require "logger"
require "json"

begin
  `convert -version`
rescue Errno::ENOENT => e
  puts(e)
  exit(1)
end

log = Logger.new(STDOUT)
log.level = Logger::INFO

force = !ARGV.shift.nil?
log.info("force: #{force}")

assets_path = File.expand_path("../assets", __dir__)
log.info("assets dir: #{assets_path}")

json_base_url = "https://raw.githubusercontent.com/smalruby/smalruby3-gui/develop"
json_paths = %w[
  src/lib/libraries/backdrops.json
  src/lib/libraries/costumes.json
  src/lib/libraries/sounds.json
]

json_paths.each do |json_path|
  json_url = File.join(json_base_url, json_path)
  output_path = File.join(assets_path, File.basename(json_path))

  if !force && File.exist?(output_path)
    log.info("already exist: #{output_path}")
    data = File.read(output_path)
  else
    log.info("reading json: #{json_url}")
    open(json_url) do |fi|
      data = fi.read
      log.info("read: #{data.length} bytes")
      File.open(output_path, "w") do |fo|
        fo.write(data)
      end
      log.info("wrote: #{output_path}")
    end
  end

  json = JSON.parse(data)
  num_assets = json.length
  json.each.with_index(1) do |asset, index|
    log.info("progress: #{index} / #{num_assets}")

    asset_url = "https://cdn.assets.scratch.mit.edu/internalapi/asset/#{asset["md5"]}/get/"

    output_path = File.join(assets_path, asset["md5"])
    if !force && File.exist?(output_path)
      log.info("already exist: #{output_path}")
    else
      log.info("reading asset: #{asset_url}")
      open(asset_url, "rb:binary") do |fi|
        data = fi.read
        log.info("read: #{data.length} bytes")
        File.open(output_path, "wb") do |fo|
          fo.write(data)
        end
        log.info("wrote: #{output_path}")
      end
    end

    if /.svg$/ =~ output_path
      svg_path = output_path
      png_path = svg_path.sub(/\.svg$/, ".png")
      if !force && File.exist?(png_path)
        log.info("already exist: #{png_path}")
      else
        log.info("converting: #{png_path}")
        system("convert", "-background", "none", svg_path, png_path)
      end
    end
  end

  log.info("done")
end
