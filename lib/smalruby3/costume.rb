module Smalruby3
  class Costume
    attr_reader :asset_id
    attr_reader :name
    attr_reader :bitmap_resolution
    attr_reader :data_format
    attr_reader :rotation_center_x
    attr_reader :rotation_center_y

    def initialize(asset)
      @asset_id = asset[:asset_id]
      @name = asset[:name]
      @bitmap_resolution = asset[:bitmap_resolution] || 1
      @data_format = asset[:data_format]
      @rotation_center_x = asset[:rotation_center_x]
      @rotation_center_y = asset[:rotation_center_y]
    end

    def image
      @image ||= DXRuby::Image.load(asset_path)
    end

    def width
      @width ||= image.width * width_scale
    end

    def height
      @height ||= image.height * height_scale
    end

    def width_scale
      @width_scale ||= World.instance.s2dx.scale / bitmap_resolution
    end

    def height_scale
      @height_scale ||= World.instance.s2dx.scale / bitmap_resolution
    end

    private

    def asset_path
      World.instance.asset_path(asset_id, data_format)
    end
  end
end
