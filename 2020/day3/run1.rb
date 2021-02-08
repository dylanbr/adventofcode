load './data.rb'
#load './test.rb'

@data = @data.split(/\n+/).map do |line|
  line.split("").map do |char|
    char == "#" ? true : false
  end
end

cols = @data[0].size
print "Found #{cols} cols and #{@data.size} rows\n"

x = 0
y = 0
hits = 0
while y < @data.size 
  if @data[y][x % cols] 
    hits += 1
  end
  x += 3
  y += 1
end
print "Hit #{hits} trees\n" 
#print "#{@data}"
