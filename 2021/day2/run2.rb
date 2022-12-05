load "./data.rb"
#load "./test.rb"

@data = @data.split(/\n/).map do |line|
  line = line.split(/\s+/)
  line[1] = line[1].to_i
  line
end

aim = 0
pos = 0
depth = 0

@data.each do |item|
  case item[0]
  when "forward"
    pos += item[1]
    depth += aim * item[1]
  when "up"
    aim -= item[1]
  when "down"
    aim += item[1]
  end
end

print "Aim = #{aim}, Pos = #{pos}, Depth = #{depth}, Answer = #{pos * depth}\n"
