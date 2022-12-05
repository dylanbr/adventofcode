load "./data.rb"
#load "./test.rb"


@data = @data.split(/\n/).map do |row|
  row.split("").map(&:to_i)
end

@adj_points = [
  [-1,  0],
  [ 1,  0],
  [ 0, -1],
  [ 0,  1]
]

def map_get(point)
  (x,y) = point
  if (x < 0) or (y < 0) or (x >= @data[0].size) or (y >= @data.size)
    nil
  else
    @data[y][x]
  end
end

def map_get_adj(point)
  (x,y) = point
  points = []
  @adj_points.each do |(ax,ay)|
    value = map_get([x+ax,y+ay])
    points.push(value) if not value.nil?
  end
  points
end

@risks = []
@data.each_with_index do |row,y|
  row.each_with_index do |value,x|
    if map_get_adj([x,y]).filter { |v| v <= value }.empty?
      @risks.push(value+1)
    end
  end
end

print "Risk = #{@risks.sum}\n"
