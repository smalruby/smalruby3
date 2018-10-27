begin
  require 'dxruby_sdl'

  DXRuby = DXRubySDL
rescue LoadError
  require 'dxruby'

  module DXRuby
    %w[
      Font
      Image
      Input
      RenderTarget
      Soiund
      SoundEffect
      Sprite
      Window
    ].each do |name|
      const_set(name, Object.send(:const_get, name))
      Object.send(:remove_const, name)
    end
  end
end
