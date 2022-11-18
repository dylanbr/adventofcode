load "./data.rb"
#load "./test.rb"

@data = @data.split(/\n+/).map do |line|
  line.split(/,/)
end.flatten.reject do |item|
  item == "x"
end.map do |item|
  item.to_i
end

@time = @data.shift
@buses = @data

@smallest = [nil,nil]
@buses.each do |bus|
  wait = ((@time % bus) - bus).abs
  if @smallest[0].nil?
    @smallest = [bus, wait]
  elsif wait <= @smallest[1]
    @smallest = [bus, wait]
  end
end

print "Answer = #{@smallest.reduce(&:*)}\n"
#print "#{@smallest}\n"
#print "Time = #{@time}, buses = #{@buses}, #{@smallest}\n"
#print "#{@data}\n"
