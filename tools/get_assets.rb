#!/usr/bin/env ruby

require "open-uri"
require "logger"
require "json"
require "fileutils"

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

blacklist = %w[
  1e81725d2d2c7de4a2dd4a145198a43c.svg
  0d192725870ef0eda50d91cab0e3c9c5.svg
  09dc888b0b7df19f70d81588ae73420e.svg
  3696356a03a8d938318876a593572843.svg
  1f5ea0d12f85aed2e471cdd21b0bd6d7.svg
  73e493e4abd5d0954b677b97abcb7116.svg
  bc68a6bdf300df7b53d73b38f74c844e.svg
  8eab5fe20dd249bf22964298b1d377eb.svg
  39ecd3c38d3f2cd81e3a17ee6c25699f.svg
  43f7d92dcf9eadf77c07a6fc1eb4104f.svg
  2582d012d57bca59bc0315c5c5954958.svg
  0579fe60bb3717c49dfd7743caa84ada.svg
  26c688d7544757225ff51cd2fb1519b5.svg
  adf61e2090f8060e1e8b2b0604d03751.svg
  594704bf12e3c4d9e83bb91661ad709a.svg
  02c5433118f508038484bbc5b111e187.svg
  10d6d9130618cd092ae02158cde2e113.svg
  85e762d45bc626ca2edb3472c7cfaa32.svg
  b10925346da8080443f27e7dfaeff6f7.svg
  b54a4a9087435863ab6f6c908f1cac99.svg
  1e6b3a29351cda80d1a70a3cc0e499f2.svg
  7edf116cbb7111292361431521ae699e.svg
  7c3c9c8b5f4ac77de2036175712a777a.svg
  f76bc420011db2cdb2de378c1536f6da.svg
  43b5874e8a54f93bd02727f0abf6905b.svg
  9aab3bbb375765391978be4f6d478ab3.svg
  22e4ae40919cf0fe6b4d7649d14a6e71.svg
  93cb048a1d199f92424b9c097fa5fa38.svg
  528613711a7eae3a929025be04db081c.svg
  ee4dd21d7ca6d1b889ee25d245cbcc66.svg
  7708e2d9f83a01476ee6d17aa540ddf1.svg
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

    if blacklist.include?(asset["md5"])
      log.info("blacklist: #{output_path}")
      FileUtils.rm_f(output_path)
      if /.svg$/ =~ output_path
        svg_path = output_path
        png_path = svg_path.sub(/\.svg$/, ".png")
        FileUtils.rm_f(png_path)
      end
      next
    end

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
