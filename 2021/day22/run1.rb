load "./data.rb"
#load "./test.rb"
#load "./test2.rb"
#load "./test3.rb"

@data = @data.split(/\n/).map do |line|
  (state, cube) = line.split(" ")
  [state,cube.split(",").map do |point|
    (axis,range) = point.split("=")
    [axis,range.split("..").map(&:to_i)]
  end.to_h]
end

@points = Hash.new(false)
@data.each do |line|
  print "Processing line = #{line}\n"
  (state,cube) = line
  if state == "on"
    state = true
  else
    state = false
  end
  ([cube['x'][0],-50].max..[cube['x'][1],50].min).each do |x|
    ([cube['y'][0],-50].max..[cube['y'][1],50].min).each do |y|
      ([cube['z'][0],-50].max..[cube['z'][1],50].min).each do |z|
        point = [x,y,z]
        if state
          @points[point] = true
        else
          @points.delete(point)
        end
      end
    end
  end
end

print "On = #{@points.size}\n"
