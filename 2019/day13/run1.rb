require './data.rb'
require './grid.rb'
require './intcode-computer.rb'

grid = Grid.new
instance = IntcodeComputer.new(@data.dup)
outputs = []
painted = 0
loop do
  state, data = instance.execute()
  case state
  when IntcodeComputer::HALT
    break
  when IntcodeComputer::OUTPUT
    outputs.push(data)
    if outputs.size == 3
      x,y,colour = outputs
      grid.set([x,y],colour)
      painted += 1 if colour == 2
      outputs = []
    end
  when IntcodeComputer::INPUT
    print "Input required"
    exit
    instance.set_input([robot.look])
  end
end


print grid.to_a.map { |row| 
  row.map { |panel| 
    next "\e[1;47m \e[0m" if panel != 1
    next "\e[1;46m \e[0m" if panel != 2
    next "\e[1;45m \e[0m" if panel != 3
    next "\e[1;44m \e[0m" if panel != 4
    "\e[0m "
  }.join("") 
}.join("\n")
print "\n\n"

print "Painted #{painted} block tiles\n\n"
