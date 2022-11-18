require "./data.rb"

def manhatten(point)
  point[0].abs + point[1].abs
end

def range(start, steps, by)
  if(by > 0)
    (start+by).upto(start+steps)
  else
    (start+by).downto(start-steps)
  end
end

points = @data.map { |series| 
  series.reduce([]) { |list, item|
    direction = item[0,1]
    steps = item[1..-1].to_i

    if list.empty?
      point = [0,0]
    else
      point = list.last.dup
    end

    if direction == "U" or direction == "L"
      move = -1
    else
      move = 1
    end
    
    if direction == "L" or direction == "R"
      axis = 0
    else
      axis = 1
    end

    for i in range(point[axis], steps, move) do
      point[axis] = i
      list.push(point.dup)
    end

    list
  }
}

intersections = points[0] & points[1]

shortest = intersections.reduce(nil) { |shortest, point|
  distance = manhatten(point)
  if shortest.nil? or shortest > distance
    distance
  else
    shortest
  end
}

print "Shortest = " + shortest.to_s + "\n"

