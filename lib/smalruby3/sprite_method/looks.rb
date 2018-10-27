module Smalruby3
  module SpriteMethod
    # Looks category methods
    module Looks
      def say(options = {})
        defaults = {
          message: '',
          second: 0,
        }
        opts = process_optional_arguments(options, defaults)

        message = opts[:message].to_s
        return if message == @current_message

        @current_message = message

        if @balloon
          @balloon.vanish
          @balloon = nil
        end

        return if message.empty?

        lines = message.to_s.lines.map { |l| l.scan(/.{1,10}/) }.flatten
        font = new_font(16)
        width = lines.map { |l| font.get_width(l) }.max
        height = lines.length * (font.size + 1)
        frame_size = 3
        margin_size = 3
        image = DXRuby::Image.new(
          width + (frame_size + margin_size) * 2,
          height + (frame_size + margin_size) * 2
        )
        image.box_fill(0,
          0,
          width + (frame_size + margin_size) * 2 - 1,
          height + (frame_size + margin_size) * 2 - 1,
          [125, 125, 125])
        image.box_fill(frame_size,
          frame_size,
          width + (frame_size + margin_size) + margin_size - 1,
          height + (frame_size + margin_size) + margin_size - 1,
          [255, 255, 255])
        lines.each.with_index do |line, row|
          image.draw_font(frame_size + margin_size,
            frame_size + margin_size + (font.size + 1) * row,
            line, font, [0, 0, 0])
        end
        @balloon = DXRuby::Sprite.new(x, y, image)
      end

      def visible=(val)
        if val
          self.collision_enable = true
        else
          self.collision_enable = false
        end
        super
      end

      def next_costume
        self.costume_index = @costume_index + 1
      end

      def switch_costume(name)
        if @costume_name__index.key?(name)
          index = @costume_name__index[name]
        else
          index = 0
        end
        self.costume_index = index
      end

      def costume_index=(val)
        @costume_index = val % @costumes.length
        self.image = @costumes[@costume_index]
      end

      def costume_name
        @costume_index__name[@costume_index]
      end
      alias_method :costume, :costume_name
    end
  end
end
