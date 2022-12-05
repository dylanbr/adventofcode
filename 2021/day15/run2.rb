load "./data.rb"
#load "./test.rb"

@map = @data.split(/\n/).map do |row|
  row.split("").map(&:to_i)
end
@tx = @map[0].size
@ty = @map.size
@mx = (@map[0].size * 5)-1
@my = (@map.size * 5)-1

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

def calc_map(point)
  (x,y) = point

  rx = x % @tx
  ry = y % @ty

  ax = x / @tx
  ay = y / @ty

  add = ax + ay

  value = (@map[ry][rx]-1 + add) % 9 + 1
  value
end

def draw_map
  (0..@my).each do |y|
    (0..@mx).each do |x|
      print @map[y][x]
    end
    print "\n"
  end
end

def get_map(point)
  (x,y) = point
  @map[y][x]
end

# Part 1 toggle
#@mx = @map[0].size-1
#@my = @map.size-1

@new_map = Hash.new(0)
@adjs = Hash.new
@nodes = Array.new
(0..@my).each do |y|
  (0..@mx).each do |x|
    point = [x,y]
    node = "#{x}_#{y}"
    print "Preparing nodes... #{node}  \r"
    @nodes.push node
    @new_map[node] = calc_map(point)
    @adjs[node] = adj(point).map do |point|
      "#{point[0]}_#{point[1]}"
    end
  end
end
@map = @new_map
print "\n"

#draw_map
#exit

INFINITY = 1 << 64

def dijkstra(source)
  @distance={}
  @previous={}
  unvisited = []
  visited = []
  @nodes.each do |node|
    @distance[node] = INFINITY #Unknown distance from source to vertex
    @previous[node] = -1 #Previous node in optimal path from source
    unvisited.push node
  end

  print "Finding paths on #{@nodes.size} nodes...\n"

  @distance[source] = 0 #Distance from source to source

#  unvisited_node = nodes.compact #All nodes initially in Q (unvisited nodes)

  count = 0
  while (unvisited.size > 0)
    u = nil;

    if visited.size > 0 
      visited.each do |min|
        if (not u) or (@distance[min] and @distance[min] < @distance[u])
          u = min
        end
      end
#      print "Found visited = #{u}\n"
      visited.delete(u)
    else
      u = unvisited.shift
#      loop do
#        u = unvisited.shift
#        break if @previous[u] == -1 or unvisited.size == 0
#      end
    end

    if (@distance[u] == INFINITY)
      break
    end

    count += 1
    print "Count = #{count}, unvisited = #{unvisited.size}, visited = #{visited.size}   \r"

    @adjs[u].each do |vertex|
      alt = @distance[u] + @map[vertex]

      dv = @distance[vertex]
      if (alt < dv)
        if dv == INFINITY
          visited.push vertex
        end
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

dijkstra("0_0")
print "\n"
find_path("#{@mx}_#{@my}")
@path =  @path.map do |point|
  @map[point]
end.reduce(&:+)

print @path - @map["0_0"]

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
