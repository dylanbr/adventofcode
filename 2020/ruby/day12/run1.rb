load "./data.rb"
#load "./test.rb"

@data = @data.split(/\n+/).map do |step|
  step.match(/([NSEWLRF])(\d+)/).captures
end.map do |step|
  [step[0],step[1].to_i]
end

@directions = ["N","E","S","W"]
@direction = 1
@pos = [0,0]

@data.each do |step|
  if step[0] == "F"
    step[0] = @directions[@direction]
  end
  case step[0]
  when "N"
    @pos[1] -= step[1]
  when "S"
    @pos[1] += step[1]
  when "W"
    @pos[0] -= step[1]
  when "E"
    @pos[0] += step[1]
  when "L"
    @direction = (@direction - (step[1] / 90)) % 4
  when "R"
    @direction = (@direction + (step[1] / 90)) % 4
  end
  #print "#{step}: New pos = #{@pos}, new direction =  #{@direction}\n"
end
#print "#{@pos}\n"
print "Answer = #{@pos[0].abs + @pos[1].abs}\n"
#print "#{@data}\n"
