load "./data.rb"
#load "./test.rb"

@data = @data.split(/\n+/).map do |line|
  line.scan(/e|w|se|sw|ne|nw/)
end

class Grid
  def initialize(grid={})
    if(grid.is_a? Grid)
      @grid = grid.grid.dup
    else
      @grid = grid.dup
    end
    home
  end

  def grid
    @grid
  end

  def pos
    @pos
  end

  def flip(pos=@pos,grid=@grid)
    if grid.has_key? pos
      grid.delete pos
    else
      grid[pos] = 1
    end
  end

  def set(pos=@pos,grid=@grid)
    grid[pos] = 1
  end

  def unset(pos=@pos,grid=@grid)
    grid.delete pos
  end

  def flipped
    @grid.keys.count
  end

  def home
    @pos = [0,0]
  end

  def move(direction,pos=@pos)
    case direction
    when "e"
      pos[0] += 1
    when "w"
      pos[0] -= 1
    when "ne"
      pos[1] -= 1
    when "sw"
      pos[1] += 1
    when "se"
      pos[0] += 1
      pos[1] += 1
    when "nw"
      pos[0] -= 1
      pos[1] -= 1
    end
  end

  def neighbours(pos=@pos)
    old = pos.dup
    list = []
    ["e","w","ne","sw","se","nw"].each do |direction|
      pos = old.dup
      move(direction,pos)
      list.push(pos)
    end
    pos = old
    list
  end

  def generation
    new_grid = @grid.dup
    @grid.keys.each do |pos|
      black_count = 0
      neighbours(pos).each do |neighbour|
        if @grid.has_key? neighbour
          black_count += 1
        else
          inner_black_count = 0
          neighbours(neighbour).each do |inner_neighbour|
            if @grid.has_key? inner_neighbour
              inner_black_count += 1
            end
          end
          if inner_black_count == 2
            set(neighbour,new_grid)
          end
        end
      end
      if (black_count == 0 or black_count > 2)
        unset(pos,new_grid)
      end
    end
    @grid = new_grid
  end
end

@grid = Grid.new
@data.each do |line|
  @grid.home
  line.each do |direction|
    @grid.move(direction)
  end
  @grid.flip
end

current = Grid.new(@grid)
100.times do |time|
  current.generation  
end

print "Answer = #{current.flipped}\n"
#print "#{@data}\n"

