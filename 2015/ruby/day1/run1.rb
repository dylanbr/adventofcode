load "./data.rb"

@data = @data.split(//)

@count = @data.reduce(0) { |count, char|
  count -= 1 if char == ")"
  count += 1 if char == "("
  count
}

print "Count = #{@count}\n"
