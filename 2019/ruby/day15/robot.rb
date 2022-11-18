class Robot
  UP = 0
  RIGHT = 1
  DOWN = 2
  LEFT = 3

  def initialize(grid)
    @direction = UP
    @position = [0,0]
    @grid = grid
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

  def move(direction, position)
    position = position.dup
    case direction
    when UP
      position[1] -= 1
    when DOWN
      position[1] += 1
    when LEFT
      position[0] -= 1
    when RIGHT
      position[0] += 1
    end
    position
  end

  def fd()
    @position = move(@direction,@position)
  end

  def paint(colour)
    @grid.set(@position, colour)
  end

  def paint_ahead(colour)
    position = move(@direction, @position)
    @grid.set(position, colour)
  end

  def seen_ahead(direction)
    position = move(direction, @position)
    @grid.get(position) != -1
  end

  def ahead(direction)
    position = move(direction, @position)
    @grid.get(position)
  end

  def look
    @grid.get(@position)
  end

  def look_left
    direction = (@direction - 1) % 4
    position = move(direction, @position)
    @grid.get(position)
  end

  def look_right
    direction = (@direction - 1) % 4
    position = move(direction, @position)
    @grid.get(position)
  end

  def face(direction)
    @direction = direction
  end

  def facing()
    @direction
  end

  def location()
    @position
  end

  def goto(position)
    @position = position
  end
end
