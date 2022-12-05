load "./data.rb"
#load "./test.rb"

@digits = {
  0 => ['a', 'b', 'c', 'e', 'f', 'g'],
  1 => ['c', 'f'],
  2 => ['a', 'c', 'd', 'e' ,'g'],
  3 => ['a', 'c', 'd', 'f' ,'g'],
  4 => ['b', 'c', 'd', 'f'],
  5 => ['a', 'b', 'd' ,'f', 'g'],
  6 => ['a', 'b', 'd', 'e', 'f', 'g'],
  7 => ['a', 'c' ,'f'],
  8 => ['a', 'b', 'c', 'd', 'e', 'f', 'g'],
  9 => ['a', 'b' ,'c', 'd', 'f', 'g']
}

@data = @data.split(/\n/).map do |line|
  line.split(' | ').map do |item|
    item.split(/\s+/).map do |digit|
      digit.split("").sort.join("")
    end
  end
end

@count = 0
@data.each do |line|
  test = Hash.new { |h, k| h[k] = [] }  
  line[0].each do |item|
    @digits.each do |number, digit|
#      print "Item size = #{item.size}, Digit size = #{digit.size}, Item = #{item}, Digit = #{digit}\n"
      if item.size == digit.size
        test[item].push number
      end
    end
  end
  map = test.map do |code, numbers|
    [numbers[0], code]
  end.to_h
  line[1].each do |item|
    if map[1] == item || map[4] == item || map[7] == item || map[8] == item
      @count += 1
    end
  end
end

print "Count = #{@count}\n"
