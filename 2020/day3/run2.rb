load './data.rb'
#load './test.rb'

@data = @data.split(/\n+/).map do |line|
  line.split("").map do |char|
    char == "#" ? true : false
  end
end

cols = @data[0].size
print "Found #{cols} cols and #{@data.size} rows\n"

hits = []
rules = [
  [1,1],
  [3,1],
  [5,1],
  [7,1],
  [1,2]
]

rules.each_with_index do |rule, c|
  x = 0
  y = 0
  hits[c] = 0
  #print "RULE ##{c} = #{rule}\n"
  while y < @data.size 
    if @data[y][x % cols] 
      hits[c] += 1
    end
    x += rule[0]
    y += rule[1]
  end
end

score = hits.reduce(:*)
print "Score = #{score}\n"
#print "Hit #{hits} trees\n" 
#print "#{@data}"
