require './data.rb'
require './intcode-computer.rb'

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

  def draw(colour)
    x,y = @position
    @map[y] = Hash.new if(@map[y].nil?)
    @map[y][x] = colour
  end

  def look
    x,y = @position
    return 0 if @map[y].nil? or @map[y][x].nil?
    @map[y][x]
  end
end

inputs = [0]
outputs = []
instance = IntcodeComputer.new(@data.dup, inputs)
@map = Hash.new
robot = Robot.new(@map)
loop do
  output = instance.execute()
  break if output.nil?
  outputs.push(output)
  if outputs.size == 2
    colour, turn = outputs
    robot.draw(colour)
    robot.turn(turn)
    robot.fd
    instance.set_input([robot.look])
    outputs = []
  end
end
print "Painted #{@map.keys.reduce(0) { |sum, y| sum += @map[y].keys.size }} tiles\n"
