load "./data.rb"

@count = @data.split(/\n/).map(&:to_i).each_cons(2).filter { |a,b| b > a }.size

print "Total is #{ @count }\n"
exit

last = @data[0]
@total = @data.reduce(0) do |total, value|
  if value > last
    total = total + 1
  end
  last = value
  total
end

print "Total is #{@total}\n"
