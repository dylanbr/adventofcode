load "./data.rb"

@data = @data.split("\n").map { |line|
  line.scan(/(\D*) (\d+),(\d+) through (\d+),(\d+)/).flatten
}

@grid = Array.new(1000) { Array.new(1000) { 0 } }

@data.each { |line|
  op = line[0]
  (line[1].to_i..line[3].to_i).each do |x|
    (line[2].to_i..line[4].to_i).each do |y|
      case op
      when "turn on"
        @grid[y][x] += 1
      when "turn off"
        if(@grid[y][x] > 0)
          @grid[y][x] -= 1
        end
      when "toggle"
        @grid[y][x] += 2 
      end
    end
  end
}

#print @data
#print @grid

count = @grid.reduce(0) { |total, row|
  total + row.reduce(&:+)
}
print "Count = #{count}\n"

#@grid.each do |row|
#  row.each do |cell|
#    print "#{cell == 1 ? "#" : "."}"
#  end
#  print "\n"
#end
