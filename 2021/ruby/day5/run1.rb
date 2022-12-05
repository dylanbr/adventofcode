load "./data.rb"
#load "./test.rb"

@data = @data.split(/\n/).map do |line|
  line.split(" -> ").map do |point|
    point = point.split(",").map(&:to_i)
  end
end

def change(a, b)
  if a == b
    0
  elsif a < b
    1
  else
    -1
  end
end

def draw(p1, p2, diagonal=false)
  xi = change(p1[0], p2[0])
  yi = change(p1[1], p2[1])
  return [] if not diagonal and xi != 0 and yi != 0

  points = []
  pos = p1
  loop do
    points.push pos.dup
    break if pos == p2
    pos = pos.zip([xi, yi]).map(&:sum)
  end
  points
end

@all = Hash.new(0)
@data.each do |line|
  draw(line[0], line[1]).each do |point|
    @all[point] += 1
  end
end

@count = @all.values.filter do |value|
  value > 1
end.size

print "Answer = #{@count}\n"

exit

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
  end
end

@count = @all.values.filter do |value|
  value > 1
end.size

#print "#{@all}\n"
print "Answer = #{@count}\n"
