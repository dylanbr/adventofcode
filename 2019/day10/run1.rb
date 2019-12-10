require './data.rb'

def index(point)
  point[1]*@y_max+point[0]
end

def draw(largest)
  print "\n"
  (0..@y_max-1).each do |y|
    (0..@x_max-1).each do |x|
      char = @data[index([x,y])]
      if char == "."
        just = "."
      else
        just = "0"
      end
      print char.to_s.rjust(largest.to_s.length,just)
    end
    print "\n"
  end
end

@y_max = @data.size
@x_max = @data[0].size
@data = @data.reduce([],&:+)

asteroids = @data.each_with_index.reduce([]) { |list, (v,i)|
  list.push([i % @y_max,i / @y_max]) if v == '#'
  list
}

largest = 0
station = nil
asteroids.each do |source|
  hits = []
  asteroids.each { |target|
    next if source == target
    dx = source[0] - target[0]
    dy = source[1] - target[1]
    angle = Math.atan2(dx,dy)
    hits.push(angle)
  }
  hits = hits.uniq.size
  if hits > largest
    largest = hits
    station = source
  end
  @data[index(source)] = hits
end

draw(largest)
print "\nLargest is #{largest} at [#{station[0]},#{station[1]}]\n"
