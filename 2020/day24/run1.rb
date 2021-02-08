load "./data.rb"
#load "./test.rb"

@data = @data.split(/\n+/).map do |line|
  line.scan(/e|w|se|sw|ne|nw/)
end

class Grid
  def initialize
    @grid = {}
    home
  end

  def grid
    @grid
  end

  def pos
    @pos
  end

  def flip
    if @grid.has_key? @pos
      @grid.delete @pos
    else
      @grid[@pos] = 1
    end
  end

  def flipped
    @grid.keys.count
  end

  def home
    @pos = [0,0]
  end

  def move(direction)
    case direction
    when "e"
      @pos[0] += 1
    when "w"
      @pos[0] -= 1
    when "ne"
      @pos[1] -= 1
    when "sw"
      @pos[1] += 1
    when "se"
      @pos[0] += 1
      @pos[1] += 1
    when "nw"
      @pos[0] -= 1
      @pos[1] -= 1
    end
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

print "Answer = #{@grid.flipped}\n"
#print "#{@data}\n"

