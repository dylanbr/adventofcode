load "./data.rb"

@data = @data.split(//)

@count = @data.each_with_index.reduce(0) { |count, (char,i)|
  count -= 1 if char == ")"
  count += 1 if char == "("
#  print "Index = #{i}, Char = #{char}, Count = #{count}\n"
  if count == -1
    print "Index = #{i+1}\n"
    exit
  end
  count
}

print "Count = #{@count}"
