load "./data.rb"
#load "./test.rb"
#load "./test2.rb"
#load "./test3.rb"

@data = @data.split(/\n/).map do |line|
  line.split("-")
end

@map = Hash.new { |h, v| h[v] = Array.new }
@data.each do |item|
  (start,finish) = item
  @map[start].push finish
  @map[finish].push start
end

@map = @map.map do |k,v|
  [k, v.uniq]
end.to_h

@map.values.concat.flatten.uniq.each do |start|
  if not @map.has_key? start
    @map[start] = []
  end
end

def find_paths(start, seen=[])
  if start == 'end'
    return [['end']]
  end
  if seen.include? start
    return []
  end
  if /[[:lower:]]/.match(start)
    seen.push start
  end
  paths = []
  @map[start].each do |finish|
    path = [start]
    find_paths(finish, seen.dup).each do |new_path|
      paths.push (path + new_path)
    end
  end
  if paths.empty?
    paths.push [start]
  end
  paths
end

@paths = find_paths("start").reject do |path|
  path.last != 'end'
end

print "Map = #{@map}\n"
#print "Paths = #{@paths}\n"
print "Found #{@paths.size} paths\n"
