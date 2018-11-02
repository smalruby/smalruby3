module Smalruby3
  module SpriteMethod
    # Variables category methods
    module Variables
      def show_variable(name)
        raise NotImplementedError, "not implemented: show_variable(#{name.inspect})"
      end

      def hide_variable(name)
        raise NotImplementedError, "not implemented: hide_variable(#{name.inspect})"
      end

      def show_list(name)
        raise NotImplementedError, "not implemented: show_list(#{name.inspect})"
      end

      def hide_list(name)
        raise NotImplementedError, "not implemented: hide_list(#{name.inspect})"
      end
    end
  end
end
