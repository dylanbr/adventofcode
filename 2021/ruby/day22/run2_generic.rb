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
  attr_accessor :points

  def initialize(*points)
    @points = points.each_slice(2).to_a
  end

  def to_s
    from = []
    to = []
    @points.each do |point|
      from.push point[0]
      to.push point[1]
    end
    "#{from.join(",")} to #{to.join(",")}"
  end

  def volume
    @points.map do |point|
      point[1] - point[2]
    end.reduce(:*)
  end

  def contains(cube)
    @points.each_with_index.map do |point, i|
      point[0] <= cube.points[i][0] and point[1] >= cube.points[i][1]
    end.all?
  end

  def intersects(cube)
    @points.each_with_index.map do |point, i|
      point[0] <= cube.points[i][1] and point[1] >= cube.points[i][0]
    end.all?
  end

  def segments(cube)
    @points.each_with_index.flat_map do |point, i|
      sections = [cube.points[i][0], cube.points[i][1]].filter { |p| p.inside?(point[0],point[1]) }
      [point[0], *sections, point[1]].each_cons(2).to_a
    end
  end

  def -(cube)
    return [] if cube.contains(self)
    return [self] if not intersects(cube)

    print "Segments = #{segments(cube).to_a}\n"
    segments(cube).map do |points|
      Cube.new(*points)
    end.filter { |c| not cube.contains(c) }

#    x_sections = [cube.x1, cube.x2].filter { |x| x.inside?(@x1,@x2) }
#    y_sections = [cube.y1, cube.y2].filter { |y| y.inside?(@y1,@y2) }
#    z_sections = [cube.z1, cube.z2].filter { |z| z.inside?(@z1,@z2) }

#    x_segments = [@x1, *x_sections, @x2].each_cons(2).to_a
#    y_segments = [@y1, *y_sections, @y2].each_cons(2).to_a
#    z_segments = [@z1, *z_sections, @z2].each_cons(2).to_a

 #   x_segments.product(y_segments, z_segments).map do |(x1,x2),(y1,y2),(z1,z2)|
 #     Cube.new(x1,x2,y1,y2,z1,z2)
 #   end.filter { |c| not cube.contains(c) }
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
    print "Cubes = #{cubes}\n"
  end
end

print "Final volume = #{@cubes.map(&:volume).sum}\n"
