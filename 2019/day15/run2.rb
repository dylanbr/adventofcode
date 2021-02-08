require "./grid.rb"
require "./intcode-computer.rb"
require "./robot.rb"
require "./data.rb"

def draw(grid)
#  print "\e[H"
  print grid.to_a.map { |row| 
    row.map { |panel| 
      next "\e[0m.\e[0m" if panel == -1
      next "\e[0mo\e[0m" if panel == 0
      next "\e[0mx\e[0m" if panel == 3
      next "\e[0mO\e[0m" if panel == 4
      next "\e[1;46m \e[0m" if panel == 1
      next "\e[1;43m \e[0m" if panel == 2
      "\e[0m "
    }.join("") 
  }.join("\n")
  print "\n\n"
#  sleep(0.004)
end

grid = Grid.new(-1)
instance = IntcodeComputer.new(@data.dup)
robot = Robot.new(grid)
robot.face(Robot::UP)
robot.paint(3)
path = [0]
target_paths = []
target = []
all_paths = []
#print "\e[2J"
count = 0
back = false
loop do
  state, data = instance.execute()
  case state
  when IntcodeComputer::HALT
    print "Halted??\n"
    break
  when IntcodeComputer::OUTPUT
    #print "Output: #{data}\n"
    case data
    when 0 # wall
      robot.paint_ahead(1)
      while robot.seen_ahead(path[-1]) and path[-1] < 4
        path[-1] += 1 # Try the next direction in the current node
      end
      if path[-1] < 4 
        robot.face path[-1]
        back = false
      else # If all directions tried then go back
        path.pop
        if path.size == 0
          break
        end
        robot.face path[-1] 
        robot.lt
        robot.lt
        back = true
      end
    when 1,2 # moved or hit
      robot.fd()
      if robot.look != 3
        if data == 1
          robot.paint(0)
        else
          robot.paint(2)
          target_paths.push path.dup
          target = robot.location
        end
        all_paths.push path.dup
      end
      if not back
        path.push(0)
        robot.face path[-1]
      else
        while robot.seen_ahead(path[-1]) and path[-1] < 4
          path[-1] += 1
        end
        if path[-1] < 4
          robot.face path[-1]
          back = false
        else
          path.pop
          if path.size == 0
            break
          end
          robot.face path[-1] 
          robot.lt
          robot.lt
          back = true
        end
      end
    end
  when IntcodeComputer::INPUT
    input = 0
    facing = robot.facing
    case facing
    when Robot::UP
      input = 1
    when Robot::DOWN
      input = 2
    when Robot::LEFT
      input = 3
    when Robot::RIGHT
      input = 4
    end
    instance.set_input([input])
  end
end

print "\n\n"
draw(grid)
shortest = target_paths.reduce(nil) do |min,path|
  next path.size if min.nil?
  next min if path.size > min
  path.size
end
print "Shortest path to target is #{shortest}\n"

robot.goto(target)
path = [0]
all_paths = []
back = false
count = 0
loop do
  robot.paint(4)
  while (robot.ahead(path[-1]) == 1 or robot.ahead(path[-1]) == 4) and path[-1] < 4
    path[-1] += 1
  end
  if path[-1] < 4
    robot.face path[-1]
    path.push(0)
    robot.fd
  else
    path.pop
    if path.size == 0
      break
    end
    robot.face path[-1] 
    robot.lt
    robot.lt
    robot.fd
  end
  all_paths.push(path.dup)
  count += 1
  if count > 10
    #break
  end
end

print "\n\n"
draw(grid)

longest = all_paths.reduce(0) do |max, path|
  next max if path.size < max
  path.size
end
print "Longest path = #{longest-1}\n"

