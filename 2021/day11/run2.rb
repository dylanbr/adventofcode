load "./data.rb"
#load "./test.rb"
#load "./test2.rb"

@map = @data.split(/\n/).map { |line| line.split("").map(&:to_i) }
@mx = @map[0].size-1
@my = @map.size-1
@map_size = @map[0].size * @map.size

@adj = [
  [-1,-1],
  [-1, 0],
  [-1, 1],
  [ 0,-1],
  # 0,0
  [ 0, 1],
  [ 1,-1],
  [ 1, 0],
  [ 1, 1]
]

def map_set(point,value)
  (x,y) = point
  return nil if x < 0 or x > @mx or y < 0 or y > @my
  @map[y][x] = value
  return value
end

def map_get(point)
  (x,y) = point
  return nil if x < 0 or x > @mx or y < 0 or y > @my
  return @map[y][x]
end

def map_inc(point)
  value = map_get(point)
  return nil if value.nil?
  value += 1
  value = map_set(point,value)
  return value
end

def map_adj(point)
  (x,y) = point
  @adj.map do |adj_point|
    (xi,yi) = adj_point
    [x+xi, y+yi]
  end.filter do |adj_point|
    (x,y) = adj_point
    if x < 0 or x > @mx or y < 0 or y > @my
      false
    else
      true
    end
  end
end



@flashes = 0
@step = 0
loop do
  # Increase all capturing flashed
  flashed = []
  (0..@mx).each do |x|
    (0..@my).each do |y|
      point = [x,y]
      value = map_inc(point)
      if value > 9
        @flashes += 1
        flashed.push(point)
      end
    end
  end


  # Increase all adj to flashed until none flash
  loop do
    prior_flashed = flashed.dup
    break if prior_flashed.empty?
    flashed = Array.new
    prior_flashed.each do |point|
      map_adj(point).each do |adj_point|
        value = map_inc(adj_point)
        if value == 10
          @flashes += 1
          flashed.push(adj_point)
        end
      end
    end
  end

  @map = @map.map do |row|
    row.map do |value|
      if value > 9
        value = 0
      end
      value
    end
  end
  @step +=1
  @total = @map.reduce(0) do |total, row|
    total += row.reduce(0) do |total, value|
      total += value
    end
  end
  break if @total == 0
end

#print @map
print "mx = #{@mx}, my = #{@my}, size = #{@map_size}\n"
print "Steps = #{@step}\n"
