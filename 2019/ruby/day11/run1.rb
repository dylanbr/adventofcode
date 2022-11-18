require './data.rb'
require './grid.rb'
require './intcode-computer.rb'
require './robot.rb'

grid = Grid.new
instance = IntcodeComputer.new(@data.dup)
robot = Robot.new(grid)

outputs = []
loop do
  state, data = instance.execute()
  case state
  when IntcodeComputer::HALT
    break
  when IntcodeComputer::OUTPUT
    outputs.push(data)
    if outputs.size == 2
      colour, turn = outputs
      robot.paint(colour)
      robot.turn(turn)
      robot.fd
      outputs = []
    end
  when IntcodeComputer::INPUT
    instance.set_input([robot.look])
  end
end

print grid.to_a.map { |row| 
  row.map { |panel| 
    next "\e[1;47m \e[0m" if panel == 1
    "\e[0m "
  }.join("") 
}.join("\n")
print "\n\n"

print "Painted #{grid.flat.size} tiles\n\n"
