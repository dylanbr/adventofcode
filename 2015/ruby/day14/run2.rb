load './data.rb'
#load './test.rb'

@reindeers = @data.split(/\n/).map do |line|
  reindeer = line.match(/(?<name>\w+) can fly (?<speed>\d+) km\/s for (?<flytime>\d+) seconds, but then must rest for (?<resttime>\d+) seconds./).named_captures.map do |k,v|
    next [k,v] if k == 'name'
    [k,v.to_i]
  end.to_h
  reindeer['distance'] = 0
  reindeer['score'] = 0
  reindeer['cycletime'] = 0
  reindeer
end

@runtime.times do |time|
  distances = []
  @reindeers.each_with_index do |reindeer, i|
    if reindeer['cycletime'] < reindeer['flytime']
      reindeer['distance'] = reindeer['distance'] + reindeer['speed']
    end
    reindeer['cycletime'] = reindeer['cycletime'] + 1
    if reindeer['cycletime'] >= (reindeer['flytime'] + reindeer['resttime'])
      reindeer['cycletime'] = 0
    end
    distances[i] = reindeer['distance']
  end
  winning = distances.max
  distances.each_with_index do |distance, i|
    if distance == winning
      @reindeers[i]['score'] = @reindeers[i]['score'] + 1
    end
  end
end

result = @reindeers.map do |reindeer|
  reindeer['score']
end.max

print result
