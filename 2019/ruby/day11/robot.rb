class Robot
  UP = 0
  RIGHT = 1
  DOWN = 2
  LEFT = 3

  def initialize(map)
    @direction = UP
    @position = [0,0]
    @map = map
  end

  def rt()
    @direction = (@direction + 1) % 4
  end

  def lt()
    @direction = (@direction - 1) % 4
  end

  def turn(way)
    if way == 1
      rt
    else
      lt
    end
  end

  def fd()
    case @direction
    when UP
      @position[1] -= 1
    when DOWN
      @position[1] += 1
    when LEFT
      @position[0] -= 1
    when RIGHT
      @position[0] += 1
    end
  end

  def paint(colour)
    @map.set(@position, colour)
  end

  def look
    @map.get(@position)
  end
end
