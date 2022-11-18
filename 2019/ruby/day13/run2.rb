require './data.rb'
require './grid.rb'
require './intcode-computer.rb'

def draw(grid,score)
  print "\e[H"
  print grid.to_a.map { |row| 
    row.map { |panel| 
      next "\e[1;47m \e[0m" if panel == 1
      next "\e[1;46m \e[0m" if panel == 2
      next "\e[1;43m \e[0m" if panel == 3
      next "\e[1;45m \e[0m" if panel == 4
      "\e[0m "
    }.join("") 
  }.join("\n")
  print "\n\nScore: #{score}\n\n" if score > 0
#  sleep(0.004)
end

grid = Grid.new
@data[0] = 2
instance = IntcodeComputer.new(@data.dup)
outputs = []
painted = 0
score = 0
ball = 0
paddle = 0
print "\e[2J"
loop do
  state, data = instance.execute()
  case state
  when IntcodeComputer::HALT
    break
  when IntcodeComputer::OUTPUT
    outputs.push(data)
    if outputs.size == 3
      x,y,colour = outputs
      if x == -1 and y == 0
        score = colour
      else
        paddle = x if colour == 3
        ball = x if colour == 4
        grid.set([x,y],colour)
        painted += 1 if colour == 2
      end
      outputs = []
      draw(grid,score)
    end
  when IntcodeComputer::INPUT
    if paddle > ball
      input = -1
    elsif paddle < ball
      input = 1
    else
      input = 0
    end
    instance.set_input([input])
  end
end

print "Final score #{score}\n"
print "Painted #{painted} block tiles\n\n"
