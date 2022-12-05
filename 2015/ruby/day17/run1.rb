load './data.rb'
#load './test.rb'

@data = @data.split(/\n/).map(&:to_i)

found = 0
(1..@data.size).each do |level|
  found = found + @data.combination(level).map do |combo|
    combo.reduce(&:+)
  end.select do |combo|
    combo == @target
  end.count
end

print "Found #{found}\n"
