@data = <<-DATA
<x=3, y=15, z=8>
<x=5, y=-1, z=-2>
<x=-10, y=8, z=2>
<x=8, y=4, z=-5>
DATA

# Test 1
#@data = <<-DATA
#<x=-1, y=0, z=2>
#<x=2, y=-10, z=-7>
#<x=4, y=-8, z=8>
#<x=3, y=5, z=-1>
#DATA

@data = @data.split("\n").map { |line|
  line.split(", ").map { |axis|
    axis[/-?\d+/].to_i
  }
}
