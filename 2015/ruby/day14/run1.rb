load './data.rb'
#load './test.rb'

@data = @data.split(/\n/).map do |line|
  reindeer = line.match(/(?<name>\w+) can fly (?<speed>\d+) km\/s for (?<flytime>\d+) seconds, but then must rest for (?<resttime>\d+) seconds./).named_captures.map do |k,v|
    next [k,v] if k == 'name'
    [k,v.to_i]
  end.to_h

  cycletime = reindeer['flytime'] + reindeer['resttime']
  cycles = @runtime / cycletime
  extra =  [@runtime % cycletime, reindeer['flytime']].min
  distance = (cycles * reindeer['speed'] * reindeer['flytime']) + (extra * reindeer['speed'])
  reindeer['distance'] = distance
  reindeer
end

result = @data.map do |reindeer|
  reindeer['distance']
end.max

print result
