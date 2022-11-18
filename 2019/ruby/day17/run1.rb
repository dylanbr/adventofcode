require './data.rb'
require './intcode-computer.rb'
require './grid.rb'

instance = IntcodeComputer.new(@data.dup)
map = ""
loop do
  state, data = instance.execute()
  case state
  when IntcodeComputer::HALT
    print "Halted??\n"
    break
  when IntcodeComputer::OUTPUT
    #print "Output: #{data}\n"
    map += data.chr
  when IntcodeComputer::INPUT
    instance.set_input([0])
    #instance.set_input([input])
  end
end

print map
print "\n"

map = map.split("\n").map do |line|
  line.split("")
end

grid = Grid.new(" ")
map.each_with_index do |row, y|
  row.each_with_index do |col, x|
    grid.set([x,y], map[y][x])
  end
end


total = 0
map.each_with_index do |row, y|
  row.each_with_index do |col, x|
    if grid.get([x,y]) == "#" and grid.get([x-1,y]) == "#" and grid.get([x+1,y]) == "#" and grid.get([x,y-1]) == "#" and grid.get([x,y+1]) == "#"
      print "Found alignment at #{x}, #{y} = #{x * y}\n"
      total += x * y
    end
  end
end
print "Sum of alignment parameters = #{total}\n"
