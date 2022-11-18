load "./data.rb"
#load "./test.rb"

@data = @data.chomp.split(",").map(&:to_i)

turn = 0
last = 0
number = 0
numbers = Hash.new(0)
@data.each do |number|
  turn += 1
  last = numbers[number]
  numbers[number] = turn
end
loop do
  turn += 1
  if last == 0
    number = 0
  else
    number = (turn-1) - last
  end
#  print "#{numbers}\n"
#  print "turn=#{turn} last = #{last}, number = #{number}\n"
  last = numbers[number]
  numbers[number] = turn
#  print "Turn=#{turn}\r"
  break if turn == 30000000
end

print "\nLast number is #{number}\n"
#print "#{numbers}\n"
#print "#{@data}\n"
