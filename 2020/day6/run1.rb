load "./data.rb"
#load "./test.rb"

@data = @data.split(/\n\n/).map do |group|
  group.split(/\n+/).join("").split("").uniq.join("").size
end.reduce(:+)

print "#{@data}\n"
