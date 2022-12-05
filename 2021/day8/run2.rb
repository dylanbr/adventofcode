load "./data.rb"
#load "./test.rb"
#load "./test2.rb"

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
      digit.split("").sort
    end
  end
end

#@count = 0 
#@data.each do |line|
#  # Find a valid mapping
#  mapping = []
#  @digits[8].permutation(7).each do |try|
#    mapped_input = line[0].map do |code|
#      code.map do |item|
#        item = @digits[8][try.index item]
#      end.sort
#    end
#
#    if @digits.values.delete_if { |number| mapped_input.include? number }.empty?
#      mapping = @digits.values.map do |code|
#        code.map do |item|
#          try[@digits[8].index item]
#        end.sort
#      end
#      break
#    end
#  end
#
#  # Convert the output
#  @count += line[1].map do |number|
#    mapping.index(number).to_s
#  end.join.to_i
#end
#
#print "Count = #{@count}\n"
#
#exit

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

  codes = Hash.new { |h, k| h[k] = [] }
  test.each do |code, numbers|
    numbers.each do |number|
      codes[number].push code
    end
  end

  #[0,6,9] group
  # 6 doesn't include both of 1
  # 9 has a 4 in
  # 0 is the one left

  #[2,3,5] group
  # only 3 includes 1
  # 5 is in 6
  # 

  # Find code for 6 because it doesn't include 1 and remove 6 from 0 and 9
  codes[6] = codes[6].filter { |code| not (codes[1][0] - code).empty?  }
  codes[9] = codes[9].filter { |code| code != codes[6][0] && (codes[4][0] - code).empty? }
  codes[0] = codes[0].filter { |code| code != codes[6][0] && code != codes[9][0] }


  # Find code for 3 because it includes 1 and remove 3 from 2 and 5
  codes[3] = codes[3].filter { |code| (codes[1][0] - code).empty?  }
  codes[5] = codes[5].filter { |code| code != codes[3][0] && (code - codes[6][0]).empty? }
  codes[2] = codes[2].filter { |code| code != codes[3][0] && code != codes[5][0] }

  codes = codes.map do |number, codes|
    [number, codes[0]]
  end.to_h
  
  answer = ""
  line[1].each do |item|
    answer += codes.invert[item].to_s
  end
  @count += answer.to_i
end

print "Count = #{@count}\n"
