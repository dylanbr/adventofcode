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

sx,sy = station
@hits = Hash.new
asteroids.each do |asteroid|
  next if asteroid == station
  dx = sx - asteroid[0]
  dy = sy - asteroid[1]
  angle = Math.atan2(dx,dy)
  distance = Math.sqrt(dx ** 2 + dy ** 2)
  @hits[angle] = [] if(@hits[angle].nil?)
  @hits[angle].push([asteroid[0],asteroid[1],distance])
end

@hits.each do |k,v|
  @hits[k] = v.sort { |a, b| a[2] <=> b[2] }
end

keys =  @hits.keys.sort
while keys.first <= 0
  keys = keys.rotate(1)
end
keys = keys.reverse

count = 0
loop do
  found = false
  keys.each do |key|
    hit = @hits[key].shift
    if(!hit.nil?)
      count += 1
      if(count == 200)
        print "\n200th asteroid destroyed at #{hit[0]},#{hit[1]} code = #{hit[0]*100+hit[1]}\n"
        exit
      end
      found = true
    end
  end
  break if !found
end
