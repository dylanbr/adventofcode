load "./data.rb"
#load "./test.rb"

@data = @data.split(/\n\n/).map do |group|
  group.split(/\n+/).map do |person|
    person.split("")
  end.reduce(:&)
end.map do |group|
  group.size
end.reduce(:+)

print "#{@data}\n"
