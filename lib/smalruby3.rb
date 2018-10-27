require_relative "smalruby3/version"
require "English"
require "pathname"

require_relative "smalruby3/dxruby"
require_relative "smalruby3/util"
require_relative "smalruby3/color"
require_relative "smalruby3/exceptions"
require_relative "smalruby3/world"
require_relative "smalruby3/sprite"

module Smalruby3
  class StopAll < Exception
  end

  class StopThisScript < Exception
  end

  class StopOtherScripts < Exception
  end

  module_function

  def start
    @started = true
    begin
      start_window_application
    rescue SystemExit
    end
  end

  def started?
    return @started
  end

  def world
    return World.instance
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

  def sprite(name)
    world.sprite(name)
  end

  private

  @started = false
  @draw_mutex = Mutex.new
  @draw_cv = ConditionVariable.new

  class << self
    private

    def init_window_application
      DXRuby::Window.caption = File.basename($PROGRAM_NAME)
      DXRuby::Window.fps = 15
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
            if !world.targets.any? { |o| o.is_a?(Stage) }
              Stage.new("Stage1")
            end
            world.targets.each do |object|
              object.start
            end
            first = false
          end

          mouse_down_and_push

          key_down_and_push

          hit

          world.sprites.delete_if do |o|
            if !o.alive?
              o.join
              o.vanished?
            end
          end

          DXRuby::Sprite.draw(world.targets)
        end
      end
    end

    def lock
      @draw_mutex.synchronize do
        yield
        @draw_cv.broadcast
      end
    end

    def mouse_down_and_push
      clickable_objects = world.targets.select { |o| o.respond_to?(:click) }
      if clickable_objects.length > 0 &&
          (DXRuby::Input.mouse_push?(DXRuby::M_LBUTTON) || DXRuby::Input.mouse_push?(DXRuby::M_RBUTTON) ||
          DXRuby::Input.mouse_push?(DXRuby::M_MBUTTON))
        buttons = []
        {
          left: M_LBUTTON,
          right: M_RBUTTON,
          center: M_MBUTTON
        }.each do |sym, const|
          if DXRuby::Input.mouse_down?(const)
            buttons << sym
          end
        end
        s = DXRuby::Sprite.new(DXRuby::Input.mouse_pos_x, DXRuby::Input.mouse_pos_y)
        s.collision = [0, 0, 1, 1]
        s.check(clickable_objects).each do |o|
          o.click(buttons)
        end
      end
    end

    def key_down_and_push
      if (keys = DXRuby::Input.keys).length > 0
        world.targets.each do |o|
          if o.respond_to?(:key_down)
            o.key_down(keys)
          end
        end
        pushed_keys = keys.select { |key| DXRuby::Input.key_push?(key) }
        if pushed_keys.length > 0
          world.targets.each do |o|
            if o.respond_to?(:key_push)
              o.key_push(pushed_keys)
            end
          end
        end
      end
    end

    def hit
      world.targets.each do |o|
        if o.respond_to?(:hit)
          o.hit
        end
      end
    end
  end
end

include Smalruby3

if Util.windows? || ENV["SMALRUBY3_WINDOWED"]
  DXRuby::Window.windowed = true
else
  DXRuby::Window.windowed = false
end

at_exit do
  Smalruby3.start if !$ERROR_INFO && !Smalruby3.started?
end
