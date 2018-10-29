require_relative "smalruby3/version"

require "English"
require "pathname"
require "dxruby"

require_relative "smalruby3/util"
require_relative "smalruby3/exceptions"
require_relative "smalruby3/world"
require_relative "smalruby3/sprite"
require_relative "smalruby3/stage"

module Smalruby3
  class StopAll < Exception
  end

  class StopThisScript < Exception
  end

  class StopOtherScripts < Exception
  end

  @started = false
  @draw_mutex = Mutex.new
  @draw_cv = ConditionVariable.new

  def sprite(name)
    Smalruby3.world.sprite(name)
  end

  class << self
    def start
      @started = true
      begin
        start_window_application
      rescue SystemExit
      end
    end

    def started?
      @started
    end

    def world
      World.instance
    end

    def s2dx
      world.s2dx
    end

    def wait
      if Thread.current == Thread.main
        sleep(1.0 / 15)
      else
        @draw_mutex.synchronize do
          @draw_cv.wait(@draw_mutex)
        end
      end
    end

    private

    def init_window_application
      DXRuby::Window.caption = File.basename($PROGRAM_NAME)
      DXRuby::Window.width = s2dx.window_width
      DXRuby::Window.height = s2dx.window_height
      DXRuby::Window.fps = s2dx.fps
      DXRuby::Window.bgcolor = [255, 255, 255]

      # HACK: DXRubyのためのサウンド関係の初期化処理。こうしておかな
      # いとDirectSoundの初期化でエラーが発生する
      begin
        DXRuby::Sound.new("")
      rescue
      end

      activate_window
    end

    def activate_window
      if Util.windows?
        require "Win32API"

        # http://f.orzando.net/pukiwiki-plus/index.php?Programming%2FTips
        # を参考にした
        hwnd_active =
          Win32API.new("user32", "GetForegroundWindow", nil, "i").call
        this_thread_id =
          Win32API.new("Kernel32", "GetCurrentThreadId", nil, "i").call
        active_thread_id =
          Win32API.new("user32", "GetWindowThreadProcessId", %w(i p), "i")
          .call(hwnd_active, 0)
        attach_thread_input =
          begin
            Win32API.new("user32", "AttachThreadInput", %w(i i i), "v")
          rescue
            Win32API.new("user32", "AttachThreadInput", %w(i i i), "i")
          end
        attach_thread_input.call(this_thread_id, active_thread_id, 1)
        Win32API.new("user32", "BringWindowToTop", %w(i), "i")
          .call(DXRuby::Window.hWnd)
        attach_thread_input.call(this_thread_id, active_thread_id, 0)

        hwnd_topmost = -1
        swp_nosize = 0x0001
        swp_nomove = 0x0002
        Win32API.new("user32", "SetWindowPos", %w(i i i i i i i), "i")
          .call(DXRuby::Window.hWnd, hwnd_topmost, 0, 0, 0, 0, swp_nosize | swp_nomove)
      end
    end

    def start_window_application
      init_window_application

      first = true
      DXRuby::Window.loop do
        lock do
          if DXRuby::Input.key_down?(DXRuby::K_ESCAPE)
            exit
          end

          if first
            world.targets.each do |o|
              o.fire(:flag_clicked)
            end
            first = false
          end

          world.targets.each do |o|
            o.draw
            o.join_threads
          end
        end
      end
    end

    def lock
      @draw_mutex.synchronize do
        yield
        @draw_cv.broadcast
      end
    end
  end
end

include Smalruby3

at_exit do
  if !$ERROR_INFO && !Smalruby3.started?
    Smalruby3.start
  end
end
