require 'singleton'

module Smalruby3
  # 環境を表現するクラス
  class World
    include Singleton

    attr_accessor :objects
    attr_accessor :board
    attr_accessor :current_stage

    def initialize
      @objects = []
      @board = nil
    end
  end
end
