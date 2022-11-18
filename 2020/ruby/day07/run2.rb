load "./data.rb"
#load "./test.rb"

@data = @data.split(/\n+/).map do |rule|
  rule.split(/ bags contain /)
end.map do |rule|
  [rule[0], rule[1].chomp(".").split(/, /).map do |target|
    target.sub(/ bag(s?)/,"")
  end.select do |target|
    target != "no other"
  end.map do |target|
    target.match(/^(\d+) (.*)$/).captures
  end]
end.to_h

def count_contained(start)
  count = 1
  @data[start].each do |rule|
    count += count_contained(rule[1]) * rule[0].to_i
  end
  count
end

contained = count_contained("shiny gold") - 1
print "#{contained}\n\n"
#print "#{@data}\n"
