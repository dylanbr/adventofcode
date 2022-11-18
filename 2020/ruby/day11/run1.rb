load "./data.rb"
#load "./test.rb"

@data = @data.split(/\n+/).map do |line|
  @width = line.size
  line.split("").map do |point|
    case point
    when "."
      0
    when "L"
      1
    when "#"
      2
    end
  end
end.flatten
@height = @data.size / @width

def pos(point)
  point[0] + (point[1] * @width)
end

def valid_point(point)
  point[0] >= 0 and point[1] >= 0 and point[0] < @width and point[1] < @height
end

def valid_seat(point)
  @data[pos(point)] > 0
end

def adjacents(seat)
  ([[-1,-1],[ 0,-1],[ 1,-1],
    [-1, 0],        [ 1, 0],
    [-1, 1],[ 0, 1],[ 1, 1]]).map do |point|
     [seat[0]+point[0],seat[1]+point[1]]
  end.reject do |point|
    !valid_point(point) or !valid_seat(point)
  end.map do |point|
    pos(point)
  end
end

seats = []
(0..@height-1).each do |y|
  (0..@width-1).each do |x|
    seat = [x,y]
    if valid_seat(seat)
      seats.push({
        "pos" => pos(seat),
        "adjacents" => adjacents(seat)
      })
    end
  end
end

curr = @data.dup
loop do
  last = curr.dup
  changed = false
  seats.each do |seat|
    occupied = seat["adjacents"].reduce(0) do |count, index|
      count += 1 if last[index] == 2
      count
    end
    old = curr[seat["pos"]]
    new = case occupied
      when 0
        2
      when 4..8
        1
      else
        old
    end
    if old != new
      curr[seat["pos"]] = new
      changed = true
    end
  end
  if not changed
    break
  end
end

print "Answer = #{curr.count(2)}\n"
#print "#{@curr}\n"
#print "WIDTH=#{@width}, HEIGHT=#{@height} #{@data}\n"
