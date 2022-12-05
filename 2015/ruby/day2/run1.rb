load "./data.rb"

#@data = "2x3x4"
#@data = "1x1x10"
@data = @data.split(/\n/).map { |line|
  sides = line.split("x").map(&:to_i)
  [sides[0]*sides[1],sides[1]*sides[2],sides[0]*sides[2]].sort
}.map { |cube|
  cube[0] + cube.reduce(0) { |total, side|
    total += 2 * side
  }
}.reduce(&:+)
print "#{@data}\n"
