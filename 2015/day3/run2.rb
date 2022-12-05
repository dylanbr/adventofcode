load "./data.rb"

#@data = ">"
#@data = "^>v<"
#@data = "^v^v^v^v^v"
#@data = "^v"
#@data = "^>v<"
#@data = "^v^v^v^v^v"

@data = @data.split("")

@visited = {}
@pos = [[0,0],[0,0]]
@person = 0
@visited[@pos[0].clone] = 1
@data.map { |direction|
  case direction
  when "^"
    @pos[@person][1] += 1
  when "v"
    @pos[@person][1] -= 1
  when "<"
    @pos[@person][0] -= 1
  when ">"
    @pos[@person][0] += 1
  end
#  print "pos = #{@pos}\n"
  @visited[@pos[@person].clone] = 1
  @person += 1
  if @person > 1
    @person = 0
  end
}
print "Visited #{@visited.keys.count} houses\n"
