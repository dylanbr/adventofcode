load "./data.rb"
#load "./test.rb"

@data = @data.split(/\n/).map do |row|
  row.split("")
end

@cucumbers = Hash.new
@data.each_with_index do |row, y|
  row.each_with_index do |val, x|
    if val != "."
      @cucumbers[[x,y]] = val
    end
  end
end

@mx = @data[0].size-1
@my = @data.size-1

def east(x)
  x += 1
  if x > @mx
    x = 0
  end
  return x
end

def south(y)
  y += 1
  if y > @my
    y = 0
  end
  return y
end


@step = 0
loop do
  moved = false

  @cucumbers = @cucumbers.map do |k, v|
    next [k,v] if v != ">"
    (x,y) = k
    new_x = east(x)
    if not @cucumbers.has_key? [new_x,y]
      k = [new_x,y]
      moved = true
    end
    [k,v]
  end.to_h

  @cucumbers = @cucumbers.map do |k, v|
    next [k,v] if v != "v"
    (x,y) = k
    new_y = south(y)
    if not @cucumbers.has_key? [x,new_y]
      k = [x,new_y]
      moved = true
    end
    [k,v]
  end.to_h

  @step += 1
  break if not moved
end

print "Steps = #{@step}\n"

