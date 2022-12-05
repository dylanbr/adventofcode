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
    point = [x+ax,y+ay]
    value = map_get(point)
    points.push(point) if not value.nil?
  end
  points
end

def map_get_adj_values(point)
  map_get_adj(point).map do |point|
    map_get(point)
  end
end

@risks = []
@data.each_with_index do |row,y|
  row.each_with_index do |value,x|
    if map_get_adj_values([x,y]).filter { |v| v <= value }.empty?
      @risks.push([x,y])
    end
  end
end

def map_fill(point)
  value = map_get(point)
  return [] if value == 9
  @data[point[1]][point[0]] = 9


  points = [value]
  map_get_adj(point).each do |point|
    points = points + map_fill(point)
  end
  points
end

@basins = []
@risks.each do |point|
  @basins.push map_fill(point)
end
@basins = @basins.sort_by(&:size)[-3,3].map(&:size)

print "Largest basins product = #{@basins.reduce(1,&:*)}\n"
#value+1)print "Risk = #{@risks.sum}\n"
