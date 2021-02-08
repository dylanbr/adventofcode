load "./data.rb"
#load "./test.rb"

def flip(tile)
  (tile.size-1).downto(0).map do |y|
    tile[y]
  end
end

def rotate(tile)
  (0..tile.size-1).map do |y|
    (0..tile.size-1).map do |x|
      tile[tile.size-1-x][y]
    end
  end
end

def find_edges(tile)
  edges = [[],[],[],[]]
  (0..tile.size-1).each do |i|
    edges[0].push(tile[0][i])
    edges[1].push(tile[i][tile.size-1])
    edges[2].push(tile[tile.size-1][i])
    edges[3].push(tile[i][0])
  end
  edges.concat(edges.map do |edge|
    flip(edge)
  end)
end

def find_neighbours(name, tile)
  neighbours = []
  my_edges = @tiles[name]["edges"]
  @tiles.each do |key, val|
    next if key == name
    common_edges = @tiles[key]['edges'] & my_edges
    if common_edges.size > 0
      neighbours.push(key)
    end
  end
  neighbours
end

@tiles = @data.split("\n\n").map do |item|
  item = item.split(/\n+/)
  tile = item[1..-1].map do |row|
    row.split(""). map do |col|
      next 1 if col == "#"
      next 0
    end
  end
  [
    item[0].match(/\d+/)[0].to_i,{
      "tile" => tile,
      "edges" => find_edges(tile)
    }
  ]
end.to_h

@answer = []
@tiles.each do |key,val|
  val['neighbours'] = find_neighbours(key,val)
  if val['neighbours'].size == 2
    @answer.push(key)
  end
  @tiles[key] = val
end
print "Answer = #{@answer.reduce(:*)}\n"

#tile = [[1,1],[0,0]]
#print "Normal=#{tile}\n"
#print "Flipped=#{flip(tile)}\n"
#print "Rotate=#{rotate(tile)}\n"
#print "Normal=#{@tiles[2311]}\n"
#print "Flipped=#{flip(@tiles[2311])}\n"
#print "Rotate=#{rotate(@tiles[2311])}\n"
#print "#{@tiles}\n"
print "Tile count = #{@tiles.count}\n"

# 11
# 00

#flip
# 00
# 11

# rotate
# 01
# 01
