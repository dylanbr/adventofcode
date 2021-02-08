load "./data.rb"
load "./monster.rb"
#load "./test.rb"

class Tile
  def initialize(tile=[])
    if tile.is_a? String
      @tile = tile.split(/\n+/).map do |row|
        row.split("").map do |item|
          next 1 if item == "#"
          next 0
        end
      end
    else
      @tile = tile
    end
    @edge_positions = [ [0,-1], [1,0], [0,1], [-1,0] ]
  end

  def tile
    @tile
  end

  def flip
    Tile.new((@tile.size-1).downto(0).map do |y|
      @tile[y]
    end)
  end

  def rotate
    Tile.new((0..@tile.size-1).map do |y|
      (0..@tile[0].size-1).map do |x|
        @tile[@tile.size-1-x][y]
      end
    end)
  end

  def fliprotate()
    (0..1).each do |flip|
      (0..3).each do |rotate|
        current = Tile.new @tile
        if flip == 1
          current = current.flip
        end
        rotate.times do
          current = current.rotate
        end
        yield current
      end
    end
  end

  def walk()
    @tile.each_index do |y|
      @tile[y].each_index do |x|
        yield x,y
      end
    end
  end

  def edges()
    if not @edges.nil?
      return @edges
    end

    edges = [[],[],[],[]]
    (0..@tile.size-1).each do |i|
      edges[0].push(@tile[0][i])
      edges[1].push(@tile[i][@tile.size-1])
      edges[2].push(@tile[@tile.size-1][i])
      edges[3].push(@tile[i][0])
    end
    edges.concat(edges.map do |edge|
      Tile.new(edge).flip.tile
    end)
    @edges = edges
  end

  def edge_walk(ex=0,ey=0)
    @edge_positions.each do |pos|
      yield pos[0]+ex, pos[1]+ey
    end
  end

  def edge_map(ex=0,ey=0)
    items = []
    edge_walk do |x,y|
      items.push yield x+ex,y+ey
    end
    items
  end

  def set(x,y,val)
    if @tile[y].nil?
      @tile[y] = []
    end
    @tile[y][x] = val
  end

  def get(x,y)
    value = ""
    if not @tile[y].nil? and not @tile[y][x].nil?
      value = @tile[y][x]
    end
    value
  end

  def isset?(x,y)
    value = get(x,y)
    if 
      (value.is_a? String and value == "#") or 
      (value.is_a? Integer and value != 0) or
      (value.is_a? Array and value.size > 0) or
      (value.is_a? Tile)
      return true
    else
      return false
    end
  end

  def row(y)
    @tile[y]
  end

  def col(x)
    @tile.map do |row|
      row[x]
    end
  end

  def count
    total = 0
    walk do |x,y|
      if isset?(x,y)
        total += 1
      end
    end
    total
  end
end

class Tiles
  def initialize(tiles)
    @tiles = tiles
    @neighbours = {}
    @tiles.each do |name, tile|
      @neighbours[name] = []
      primary_edges = tile.edges
      @tiles.each do |neighbour, neighbour_tile|
        next if name == neighbour
        common_edges = neighbour_tile.edges & primary_edges
        if common_edges.size > 0
          @neighbours[name].push(neighbour)
        end
      end
    end
  end

  def [](name)
    @tiles[name]
  end

  def each
    tiles.each do |key,val|
      yield key, val
    end
  end

  def neighbours(name)
    @neighbours[name]
  end

  def corners
    list = []
    @neighbours.each do |name, items|
      if items.size == 2
        list.push(name)
      end
    end
    list
  end
end

# Translate data and generate edges for each tile
@tiles = Tiles.new(@data.split("\n\n").map do |item|
  item = item.split(/\n+/)
  [item[0].match(/\d+/)[0].to_i, Tile.new(item[1..-1].join("\n"))]
end.to_h)
@monster = Tile.new(@monster)

# Populate map
@map = Tile.new([[@tiles.corners.first]])
@map.walk do |col,row|
  tile_name = @map.get(col,row)
  @tiles.neighbours(tile_name).each do |neighbour|
    found = false
    @map.edge_walk(col,row) do |x,y|
      if @map.get(x,y) == neighbour
        found = true
        break
      end
    end
    next if found
    best = nil
    empty = nil
    @map.edge_walk(col,row) do |x,y|
      next if x < 0 or y < 0
      @map.edge_walk(x,y) do |ix,iy|
        check_tile = @map.get(ix,iy)
        next if check_tile == tile_name or check_tile == ""
        if @tiles.neighbours(check_tile).include? neighbour
          best = [x,y]
          break
        end
      end
      break if not best.nil?
      if empty.nil? and not @map.isset?(x,y)
        empty = [x,y]
      end
    end
    if best.nil?
      best = empty
    end
    @map.set(best[0],best[1],neighbour)
    next
  end
end

print "Map = #{@map.tile}\n"

# Orient tiles
@tiles[@map.get(0,0)].fliprotate do |first_tile|
  @tilemap = Tile.new
  first = true
  success = true
  @map.walk do |col,row|
    tile_name = @map.get(col,row)
    other_tiles = @map.edge_map(col,row) do |x,y|
      next nil if not @tilemap.isset?(x,y)
      @tilemap.get(x,y)
    end
    new_tile = @tiles[tile_name]
    found = false
    if first
      found = true
      new_tile = first_tile
    else
      new_tile.fliprotate do |check_tile|
        match = true
        other_tiles.each_with_index do |other_tile, other_index|
          next if other_tile.nil?
          has_match = case other_index
                      when 0 #above
                        other_tile.row(-1) == check_tile.row(0)
                      when 1 #right
                        other_tile.col(0) == check_tile.col(-1)
                      when 2 #below
                        other_tile.row(0) == check_tile.row(-1)
                      when 3 #left
                        other_tile.col(-1) == check_tile.col(0)
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
      @tilemap.set(col,row,new_tile)
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
      tile.tile.map do |tile_row|
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
#print "\n#{draw_map(@tilemap.tile)}\n"

@tilemap = Tile.new(@tilemap.tile.map do |row|
  row.map do |tile|
    tile = tile.tile
    tile.shift
    tile.pop
    tile.map do |tile_row|
      tile_row.shift
      tile_row.pop
      tile_row
    end
    Tile.new tile
  end
end)

@flatmap = Tile.new(@tilemap.tile.map do |row|
  row.map do |tile|
    tile.tile
  end.transpose.map do |tile_row|
    tile_row.reduce(&:concat)
  end.map do |tile_row|
    tile_row
  end
end.reduce(&:concat))

@monster_count = 0
@flatmap.fliprotate do |currmap|
  @monster_count = 0
  currmap.walk do |x,y|
    found = true
    @monster.walk do |mx,my|
      if @monster.isset?(mx,my) and not currmap.isset?(x+mx,y+my)
        found = false
        break
      end
    end
    @monster_count += 1 if found
  end
  break if @monster_count > 0
end
print "Found #{@monster_count} monsters\n"

print "Part 1 = #{@tiles.corners.reduce(:*)}\n"
#print "Map pixels = #{count_pixels(@finalmap)}\n"
print "Part 2 = #{@flatmap.count - (@monster.count * @monster_count)}\n"
