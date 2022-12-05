load "./data.rb"
#load "./test.rb"

@data = @data.split(/\n/).map do |line|
  line.split(" -> ").map do |point|
    point = point.split(",").map(&:to_i)
  end
end

@all = {}
@data.each do |line|
  if line[0][0] == line[1][0]
    x = line[0][0]
    (y1, y2) = [line[0][1], line[1][1]].sort
    (y1..y2).each do |y|
      key = [x,y]
      if @all[key].nil?
        @all[key] = 1
      else
        @all[key] += 1
      end
    end
  elsif line[0][1] == line[1][1]
    y = line[0][1]
    (x1, x2) = [line[0][0], line[1][0]].sort
    (x1..x2).each do |x|
      key = [x,y]
      if @all[key].nil?
        @all[key] = 1
      else
        @all[key] +=1
      end
    end
  else
    if line[0][0] > line[1][0]
      xi = -1
    else
      xi = 1
    end
    if line[0][1] > line[1][1]
      yi = -1
    else
      yi = 1
    end
    curr = line[0].dup
    loop do
      key = curr.dup
      if @all[key].nil?
        @all[key] = 1
      else
        @all[key] += 1
      end
      break if curr[0] == line[1][0]
      curr[0] += xi
      curr[1] += yi
    end
  end
end

@count = @all.values.filter do |value|
  value > 1
end.size

#print "#{@all}\n"
print "Answer = #{@count}\n"
