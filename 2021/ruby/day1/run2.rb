load "./data.rb"

@count = @data.split(/\n/).map(&:to_i).each_cons(3).map(&:sum).each_cons(2).filter { |a, b| b > a }.size

print @count

exit

# Initial version after map(&:sum)
last = @data[0]
@total = @data.reduce(0) do |total, value|
  total += 1 if value > last
  last = value
  total
end

print "Total is #{@total}\n"
