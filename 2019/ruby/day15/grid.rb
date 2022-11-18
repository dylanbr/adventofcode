class Grid
  def initialize(default=0)
    @data = Hash.new
    @default = default
  end

  def set(point, value)
    x,y = point
    @data[y] = Hash.new if(@data[y].nil?)
    @data[y][x] = value
  end

  def get(point)
    x,y = point
    return @default if @data[y].nil? or @data[y][x].nil?
    @data[y][x]
  end

  def raw
    @data
  end
  
  def flat
    @data.values.reduce([]) { |points,row| points += row.values }
  end

  def to_a
    min_y = @data.keys.min
    max_y = @data.keys.max
    min_x = @data.keys.map { |i| @data[i].keys.min }.min
    max_x = @data.keys.map { |i| @data[i].keys.max }.max
    (0..max_y-min_y).to_a.map { |y|
      (0..max_x-min_x).to_a.map { |x|
        get([x+min_x,y+min_y])
      }
    }
  end
end
