load "./data.rb"
#load "./test.rb"

@data = @data.split(/\n+/).map do |line|
  line.split(/,/)
end.flatten.map do |item|
  next 0 if item == "x"
  item.to_i
end

@time = @data.shift
@buses = {}
offset = 0
@largest = [nil,nil]
@data.each do |bus|
  if bus != 0
    @buses[bus] = offset
    if @largest[0].nil? or @largest[0] < bus
      @largest = [bus, offset]
    end
  end
  offset += 1
end

step = 1
count = 0
@buses.each do |bus, offset|
  while (count + offset) % bus != 0 do
    count += step
  end
  step *= bus
end

print "Answer = #{count}\n"


#print "#{@smallest}\n"
#print "Time = #{@time}, buses = #{@buses}, largest = #{@largest}\n"
#print "#{@data}\n"

