load "./data.rb"

#@data = "2x3x4"
#@data = "1x1x10"
@data = @data.split(/\n/).map { |line|
  sides = line.split("x").map(&:to_i).sort
}.map { |cube|
  cube.reduce(&:*) + (2*cube[0]) + (2*cube[1])
}.reduce(&:+)
print "#{@data}\n"
