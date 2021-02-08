load "./data.rb"
load "./monster.rb"
load "./test.rb"

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

def fliprotate(tile)
  (0..1).each do |flip|
    (0..3).each do |rotate|
      current = tile
      if flip == 1
        current = flip(current)
      end
      rotate.times do
        current = rotate(current)
      end
      yield current
    end
  end
end

def mapwalk(tile)
  tile.each_index do |y|
    tile[y].each_index do |x|
      yield x,y
    end
  end
end

def edgewalk()
  @edge_positions.each do |pos|
    yield pos[0], pos[1]
  end
end

def edgemap()
  items = []
  edgewalk do |x,y|
    items.push yield x,y
  end
  items
end

def map_set(tile,x,y,val)
  if tile[y].nil?
    tile[y] = []
  end
  tile[y][x] = val
end

def map_get(tile,x,y)
  value = ""
  if not tile[y].nil? and not tile[y][x].nil?
    value = tile[y][x]
  end
  value
end

def map_isset?(tile,x,y)
  value = map_get(tile,x,y)
  if 
    (value.is_a? String and value == "#") or 
    (value.is_a? Integer and value != 0) or
    (value.is_a? Array and value.size > 0)
    return true
  else
    return false
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

# Translate data and generate edges for each tile
@monster = @monster.split(/\n+/).map do |row|
  row.split("")
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

@edge_positions = [
  [0,-1],
  [1,0],
  [0,1],
  [-1,0]
]

# List possible neighbours for each tile and find a corner tile to start populating
@corner = nil
@tiles.each do |key,val|
  val['neighbours'] = find_neighbours(key,val)
  if @corner.nil? and val['neighbours'].size == 2
    @corner = key
  end
  @tiles[key] = val
end

# Populate map
@map = [[@corner]]
loop do
  changed = false
  mapwalk(@map) do |col,row|
    tile_name = @map[row][col]
    @tiles[tile_name]['neighbours'].each do |neighbour|
      found = false
      edgewalk do |ex,ey|
        if map_get(@map,col+ex,row+ey) == neighbour
          found = true
        end
      end
      next if found
      best = nil
      empty = nil
      edgewalk do |ex,ey|
        x = col + ex
        y = row + ey
        next if x < 0 or y < 0
        edgewalk do |iex,iey|
          ix = x + iex
          iy = y + iey
          check_tile = map_get(@map,ix,iy)
          next if check_tile == tile_name or check_tile == ""
          if @tiles[check_tile]['neighbours'].include? neighbour
            best = [x,y]
          end
        end
        break if not best.nil?
        empty = [x,y] if empty.nil? and not map_isset?(@map,x,y)
      end
      if best.nil?
        best = empty
      end
      map_set(@map,best[0],best[1],neighbour)
      changed = true
      next
    end
  end
  break if not changed
end

print "Map = #{@map}\n"

# Orient tiles
fliprotate(@tiles[@map[0][0]]['tile']) do |first_tile|
  @tilemap = []
  first = true
  success = true
  mapwalk(@map) do |col,row|
    tile_name = @map[row][col]
    other_tiles = edgemap do |ex,ey|
      x = col + ex
      y = row + ey
      next nil if not map_isset?(@tilemap,x,y)
      @tilemap[y][x]
    end
    new_tile = @tiles[tile_name]['tile']
    found = false
    if first
      found = true
      new_tile = first_tile
    else
      fliprotate(new_tile) do |check_tile|
        match = true
        other_tiles.each_with_index do |other_tile, other_index|
          next if other_tile.nil?
          has_match = case other_index
          when 0 #above
            other_tile[other_tile.size-1] == check_tile[0]
          when 1 #right
            other_tile.map do |row|
              row[0]
            end == check_tile.map do |row|
              row[row.size-1]
            end
          when 2 #below
            other_tile[0] == check_tile[check_tile.size-1]
          when 3 #left
            other_tile.map do |row|
              row[row.size-1]
            end == check_tile.map do |row|
              row[0]
            end
          end
          match = false if not has_match
        end
        if match
          new_tile = check_tile
          found = true
          break
        end
      end
    end
    if found
      map_set(@tilemap,col,row,new_tile)
    else 
      success = false
      break
    end
    first = false
  end
  break if success
end

def draw_map(my_map) 
  my_map.map do |row|
    row.map do |tile|
      tile.map do |tile_row|
        tile_row.map do |cell|
          next "#" if cell == 1
          next "." if cell == 0
        end.join("")
      end
    end.transpose.map do |tile_row|
      tile_row.join(" ")
    end.join("\n")
  end.join("\n\n")
end
#print "\n#{draw_map(@tilemap)}\n"

@tilemap = @tilemap.map do |row|
  row.map do |tile|
    tile.shift
    tile.pop
    tile.map do |tile_row|
      tile_row.shift
      tile_row.pop
      tile_row
    end
  end
end

@monstermap = @tilemap.map do |row|
  row.map do |tile|
    tile.map do |tile_row|
      tile_row.map do |cell|
        next "#" if cell == 1
        next "." if cell == 0
      end.join("")
    end
  end.transpose.map do |tile_row|
    tile_row.join("")
  end.map do |tile_row|
    [tile_row]
  end
end

@finalmap = []
@monstermap.each do |row|
  row.map do |tile_row|
    @finalmap.push(tile_row[0].split(""))
  end
end

@monster_count = 0
fliprotate(@finalmap) do |currmap|
  @monster_count = 0
  mapwalk(currmap) do |x,y|
    found = true
    mapwalk(@monster) do |mx,my|
      if @monster[my][mx] == "#" and not map_isset?(currmap,x+mx,y+my)
        found = false
        break
      end
    end
    @monster_count += 1 if found
  end
  break if @monster_count > 0
end
#print "Found #{@monster_count} monsters\n"

def count_pixels(image)
  image.reduce(0) do |pixels, row|
    if row.is_a? String
      row = row.split("")
    end
    pixels = pixels + row.reduce(0) do |subpixels, char|
      if char == "#"
        subpixels += 1
      end
      subpixels
    end
    pixels
  end
end

#@outputmap = @finalmap.map do |row|
#  row.join("")
#end.join("\n")
#print "#{@outputmap}\n"


@answer = []
@tiles.each do |key,val|
  val['neighbours'] = find_neighbours(key,val)
  if val['neighbours'].size == 2
    @answer.push(key)
  end
  @tiles[key] = val
end
print "Part 1 = #{@answer.reduce(:*)}\n"
#print "Map pixels = #{count_pixels(@finalmap)}\n"
print "Part 2 = #{count_pixels(@finalmap) - (count_pixels(@monster) * @monster_count)}\n"

# 1837 map pixels = 20?
# 1537 is right
# 1777 too high
# 1762 too high


#tile = [[1,1],[0,0]]
#print "Normal=#{tile}\n"
#print "Flipped=#{flip(tile)}\n"
#print "Rotate=#{rotate(tile)}\n"
#print "Normal=#{@tiles[2311]}\n"
#print "Flipped=#{flip(@tiles[2311])}\n"
#print "Rotate=#{rotate(@tiles[2311])}\n"
#print "#{@tiles}\n"
#print "Tile count = #{@tiles.count}\n"

# 11
# 00

#flip
# 00
# 11

# rotate
# 01
# 01
