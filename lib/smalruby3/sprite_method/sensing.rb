module Smalruby3
  module SpriteMethod
    # Sensing category methods
    module Sensing
      def touching?(object)
        #(x,y)で引数を使ってスプライトに触れているかを調べることによって触れているという状態を調べるメソッドを作る
        #(x,y)を与えれば、その座標にスプライトがいるかどうかを調べる
      #ob_x = object_x
      #ob_y = object_y
      #x + a >=  ob_x && x - a <= ob_x &&
         # y - b <=  ob_y && y + b >= ob_y 
      #end
      case (object)
      when "_edge_"
         # TODO: check with rotation_center_{x,y}, costume {width,height}, costume transparent
          x <= SmalrubyToDXRuby::SCREEN_LEFT || x >= SmalrubyToDXRuby::SCREEN_RIGHT ||
            y <= SmalrubyToDXRuby::SCREEN_BOTTOM || y >= SmalrubyToDXRuby::SCREEN_TOP
      when "_mouse_"
          # TODO: check touching mouse
          #　TODO:　マウスに触れているかを、その下にスクリプトの画像があるかで判断する。ピクセルで判断すればできる。
          #画像はcostumeの可能性がある。
          #画像に触れているを座標からいけるか。コスチュームにあるかどうかを座標の集まりとして認識できるか。
          #将来的にピクセル単位でやる。
          #mouse = [Input.mousePosX,Input.mousePosY]
          #aaa =
          #mouse == aaa
          dx_mouse_x = Input.mousePosX
          dx_mouse_y = Input.mousePosY
          mouse_x, mouse_y = *dx2s.position(dx_mouse_x, dx_mouse_y)
          puts "(#{mouse_x}, #{mouse_y}), (#{x}, #{y}) [#{costume.width},#{costume.height}][#{costume.width/2}][#{x + costume.width/2 <= mouse_x}, #{x - costume.width/2 >= mouse_x}, #{y - costume.height/2 >= mouse_y}, #{y + costume.height/2 <= mouse_y}][#{}]"
          x + costume.width/2 >= mouse_x  && x - costume.width/2 <= mouse_x &&
          y - costume.height/2 <= mouse_y && y + costume.height/2 >= mouse_y
              #没になったやり方　消すのがもったいなくて消してない。
          # def touching?(x,y) 
         #   x = object(0)
          #  y = object(1)
       # end
        #  x + costume.width/2 >= mouse_x  && x - costume.width/2 <= mouse_x &&
         #  y - costume.height/2 <= obj_y && y + costume.height/2 >= mouse_y
      
      else
        if !sprite(object)
             # TODO: check touching sprite
             raise ArgumentError, "invalid object: #{object}"
        end
      end
      end
    end
  end
end
