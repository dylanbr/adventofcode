load "./data.rb"

#@data = ">"
#@data = "^>v<"
#@data = "^v^v^v^v^v"

@data = @data.split("")

@visited = {}
@pos = [0,0]
@visited[@pos.clone] = 1
@data.map { |direction|
  case direction
  when "^"
    @pos[1] += 1
  when "v"
    @pos[1] -= 1
  when "<"
    @pos[0] -= 1
  when ">"
    @pos[0] += 1
  end
#  print "pos = #{@pos}\n"
  @visited[@pos.clone] = 1
}
print "Visited #{@visited.keys.count} houses\n"
