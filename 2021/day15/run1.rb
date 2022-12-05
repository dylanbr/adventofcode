load "./data.rb"
#load "./test.rb"

@map = @data.split(/\n/).map do |row|
  row.split("").map(&:to_i)
end
@mx = @map[0].size-1
@my = @map.size-1

def dist(a,b)
  (x1,y1) = a
  (x2,y2) = b
  ( (x2-x1) ** 2 ) + ( (y2-y1) ** 2 )
end

def adj(point)
  [ [-1,0], [0,-1], [1,0], [0,1] ].map do |adj_point|
    (x,y) = point
    (ax,ay) = adj_point
    [x+ax, y+ay]
  end.filter do |point|
    (x,y) = point
    next true if x >= 0 and y >= 0 and x <= @mx and y <= @my
  end
end

INFINITY = 1 << 64

def dijkstra(source)
  @distance={}
  @previous={}
  unvisited = []
  (0..@mx).each do |x|
    (0..@my).each do |y|
      node = [x,y]
      @distance[node] = INFINITY #Unknown distance from source to vertex
      @previous[node] = -1 #Previous node in optimal path from source
      unvisited.push node
    end
  end

  @distance[source] = 0 #Distance from source to source

#  unvisited_node = nodes.compact #All nodes initially in Q (unvisited nodes)

  while (unvisited.size > 0)
    u = nil;

    unvisited.each do |min|
      if (not u) or (@distance[min] and @distance[min] < @distance[u])
        u = min
      end
    end

    if (@distance[u] == INFINITY)
      break
    end

    print "Unvisited = #{unvisited.size}\r"
    unvisited.delete(u)

    adj(u).each do |vertex|
      (x,y) = vertex
      alt = @distance[u] + @map[y][x]

      if (alt < @distance[vertex])
        @distance[vertex] = alt
        @previous[vertex] = u  #A shorter path to v has been found
      end
    end
  end
end

def find_path(dest)
    @path = []
    if @previous[dest] != -1
      find_path @previous[dest]
    end
    @path << dest
end

dijkstra([0,0])
find_path([@mx,@my])
@path =  @path.map do |point|
  (x,y) = point
  @map[y][x]
end.reduce(&:+)

print @path - @map[0][0]

exit

def astar(start, goal)
  open = [start]
  from = {}

  gScore = Hash.new(1 << (1.size * 8 - 2) - 1)
  gScore[start] = 0
  fScore = Hash.new(1 << (1.size * 8 - 2) - 1)
  fScore[start] = dist(start, goal)

  loop do
    break if open.empty?

    curr = fScore.sort_by { |key, value| value }.first[0]
    if curr == goal
      return from
    end

    open.delete curr
    print "Processing curr = #{curr}\n"
    adj(curr).each do |neighbour|
      tentative_gScore = gScore[curr] + @map[neighbour[1]][neighbour[0]] # dist(curr, neighbour)
      if tentative_gScore < gScore[neighbour]
        print "yes"
        from[neighbour] = curr
        gScore[neighbour] = tentative_gScore
        fScore[neighbour] = tentative_gScore + dist(neighbour, goal)
        if not open.include? neighbour
          open.push neighbour
        end
      end
    end
  end
end

@path = astar([0,0],[@mx,@my])


exit

def adj(point)
  [ [1,0], [0,1] ].map do |adj_point|
    (x,y) = point
    (ax,ay) = adj_point
    [x+ax, y+ay]
  end.filter do |point|
    (x,y) = point
    next true if x >= 0 and y >= 0 and x <= @mx and y <= @my
  end
end

@highest = nil
@known = Hash.new(0)
def path(point, seen=Array.new)
#  print "On point=#{point}, seen=#{seen}, known=#{@known}\n"
  if @known.has_key? point
    return @known[point]
  end

  (x,y) = point
  total = @map[y][x]

  amounts = []
  adj(point).each do |adj_point|
    if not seen.include? adj_point
      amounts.push path(adj_point, seen.dup.push(adj_point))
    end
  end

  if amounts.size > 0
    total += amounts.min
  end
  
  @known[point] = total

  total
end

@total = path([0,0]) - @map[0][0]
print "Total = #{@total}\n"
