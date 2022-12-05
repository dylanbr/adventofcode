load './data.rb'
#load './test.rb'

@data = @data.split(/\n/).map(&:to_i)

found = 0
(1..@data.size).each do |level|
  total = @data.combination(level).map do |combo|
    combo.reduce(&:+)
  end.select do |combo|
    combo == @target
  end
  if total.size > 0
    print "Total = #{total.size}\n"
    exit
  end
end
