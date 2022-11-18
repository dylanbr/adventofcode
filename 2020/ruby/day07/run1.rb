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

@contained = {}
@data.each do |bag, rules|
  rules.each do |rule|
    if @contained[rule[1]].nil?
      @contained[rule[1]] = []
    end
    @contained[rule[1]].push(bag)
  end
end

def all_contained(start)
  containers = [start]
  if !@contained[start].nil?
    @contained[start].each do |bag|
      containers.concat(all_contained(bag))
    end
  end
  containers
end

@all = all_contained("shiny gold").sort.uniq.size - 1

print "#{@all}\n\n"
#print "#{@contained}\n\n"
#print "#{@data}\n"
