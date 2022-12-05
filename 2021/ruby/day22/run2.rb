load "./data.rb"
#load "./test.rb"
load "./test2.rb"
#load "./test3.rb"

class Integer
  def inside?(a,b)
    a < self and self < b
  end
end

class Cube
  attr_accessor :x1, :x2, :y1, :y2, :z1, :z2

  def initialize(x1,x2,y1,y2,z1,z2)
    @x1 = x1
    @x2 = x2
    @y1 = y1
    @y2 = y2
    @z1 = z1
    @z2 = z2
  end

  def to_s
    "#{@x1},#{@y1},#{@z1} to #{@x2},#{@y2},#{@z2}"
  end

  def volume
    (@x2-@x1) * (@y2-@y1) * (@z2-@z1)
  end

  def contains(cube)
	@x1 <= cube.x1 and
    @x2 >= cube.x2 and
    @y1 <= cube.y1 and
    @y2 >= cube.y2 and
    @z1 <= cube.z1 and
    @z2 >= cube.z2
  end

  def intersects(cube)
    @x1 <= cube.x2 and
    @x2 >= cube.x1 and
    @y1 <= cube.y2 and
    @y2 >= cube.y1 and
    @z1 <= cube.z2 and
    @z2 >= cube.z1
  end

  def -(cube)
    return [] if cube.contains(self)
    return [self] if not intersects(cube)

    x_sections = [cube.x1, cube.x2].filter { |x| x.inside?(@x1,@x2) }
    y_sections = [cube.y1, cube.y2].filter { |y| y.inside?(@y1,@y2) }
    z_sections = [cube.z1, cube.z2].filter { |z| z.inside?(@z1,@z2) }

    x_segments = [@x1, *x_sections, @x2].each_cons(2).to_a
    y_segments = [@y1, *y_sections, @y2].each_cons(2).to_a
    z_segments = [@z1, *z_sections, @z2].each_cons(2).to_a

    print "Segments = #{x_segments.product(y_segments, z_segments).to_a}\n"
    x_segments.product(y_segments, z_segments).map do |(x1,x2),(y1,y2),(z1,z2)|
      Cube.new(x1,x2,y1,y2,z1,z2)
    end.filter { |c| not cube.contains(c) }
  end
end

@cubes = @data.split(/\n/).map do |line|
  (state, cube) = line.split(" ")
  [
    state=="on"?true:false,
    Cube.new(*cube.split(",").flat_map do |point|
      (_,range) = point.split("=")
      range.split("..").map(&:to_i).each_slice(2).flat_map { |a,b| [a,b+1] }
    end)
  ]
end.each_with_index.reduce([]) do |cubes, ((state, new_cube), count)|
  print "Processing line ##{count+1}\n"

  cubes.flat_map do |existing_cube|
    existing_cube - new_cube
  end.tap do |cubes|
    cubes.push(new_cube) if state
  end
end

print "Final volume = #{@cubes.map(&:volume).sum}\n"
