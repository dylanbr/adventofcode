load "./data.rb"
#load "./test.rb"

@xa = @data.match(/x=(-?\d+\.\.-?\d+)/)[1].split("..").map(&:to_i)
@ya = @data.match(/y=(-?\d+\.\.-?\d+)/)[1].split("..").map(&:to_i)

@x_range = Range.new(@xa[0],@xa[1])
@y_range = Range.new(@ya[0],@ya[1])
print "X range = #{@x_range}, Y range = #{@y_range}\n"

def fire (xv, yv)
  x = 0
  y = 0
  max_y = 0
#  print "Start loop for xv=#{xv}, yv=#{yv}\n"
  loop do
    x += xv
    y += yv
    max_y = y if y > max_y
    if xv > 0
      xv -= 1
    elsif x < 0
      xv += 1
    end
    yv -= 1
#    print " x=#{x}, y=#{y}, xv=#{xv}, yv=#{yv}, max=#{max_y}\n"
    return max_y if @x_range.include?(x) and @y_range.include?(y)
    return nil if x > @x_range.max
    return nil if xv == 0 and y < @y_range.min and yv < 0 
  end
end

@count = 0
(1..@x_range.max).each do |x|
  #(-1000..1000).each do |y|
  (@y_range.min..-@y_range.min).each do |y|
    max_y = fire(x,y)
#    print "Result for (#{x},#{y}) = #{max_y}\n"
    if not max_y.nil?
      @count += 1
    end
  end
end

print "Count = #{@count}\n"
#print "#{fire(4,4)}\n"

