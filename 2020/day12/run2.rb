load "./data.rb"
#load "./test.rb"

@data = @data.split(/\n+/).map do |step|
  step.match(/([NSEWLRF])(\d+)/).captures
end.map do |step|
  [step[0],step[1].to_i]
end

@directions = ["N","E","S","W"]
@direction = 1
@ship = [0,0]
@waypoint = [10,-1]

@data.each do |step|
  case step[0]
  when "N"
    @waypoint[1] -= step[1]
  when "S"
    @waypoint[1] += step[1]
  when "W"
    @waypoint[0] -= step[1]
  when "E"
    @waypoint[0] += step[1]
  when "L"
    rotate = (step[1] / 90) % 4
    case rotate
    when 1
      @waypoint[0],@waypoint[1] = @waypoint[1],-@waypoint[0]
    when 2
      @waypoint[0],@waypoint[1] = -@waypoint[0],-@waypoint[1]
    when 3
      @waypoint[0],@waypoint[1] = -@waypoint[1],@waypoint[0]
    end
  when "R"
    rotate = (step[1] / 90) % 4
    case rotate
    when 1
      @waypoint[0],@waypoint[1] = -@waypoint[1],@waypoint[0]
    when 2
      @waypoint[0],@waypoint[1] = -@waypoint[0],-@waypoint[1]
    when 3
      @waypoint[0],@waypoint[1] = @waypoint[1],-@waypoint[0]
    end
  when "F"
    @ship[0],@ship[1] = @ship[0]+(@waypoint[0]*step[1]),@ship[1]+(@waypoint[1]*step[1])
  end
  #print "#{step}: New ship = #{@ship}, new waypoint = #{@waypoint}\n"
end
#print "#{@pos}\n"
print "Answer = #{@ship[0].abs + @ship[1].abs}\n"
#print "#{@data}\n"

#[ -4,-10],[ 0,-1],[10,-4]
#[ -1,  0],[ 0, 0],[ 1, 0]
#[-10,  4],[ 0, 1],[ 4,10]

