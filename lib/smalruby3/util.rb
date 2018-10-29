module Smalruby3
  module Util
    module_function

    def process_options(options, defaults)
      unknown_keys = options.keys - defaults.keys
      if unknown_keys.length > 0
        s = unknown_keys.map { |k| "#{k}: #{options[k].inspect}" }.join(", ")
        fail ArgumentError, "Unknown options: #{s}"
      end
      defaults.merge(options)
    end

    def print_exception(exception)
      $stderr.puts("#{exception.class}: #{exception.message}")
      $stderr.puts("        #{exception.backtrace.join("\n        ")}")
    end

    def windows?
      ENV["SMALRUBY_WINDOWS_MODE"] || /windows|mingw|cygwin/i =~ RbConfig::CONFIG["arch"]
    end

    def raspberrypi?
      ENV["SMALRUBY_RASPBERRYPI_MODE"] || /armv6l-linux-eabihf/i =~ RbConfig::CONFIG["arch"]
    end

    def osx?
      ENV["SMALRUBY_OSX_MODE"] || /darwin/i =~ RbConfig::CONFIG["arch"]
    end
  end
end
