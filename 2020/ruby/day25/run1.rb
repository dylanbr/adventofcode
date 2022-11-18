load "./data.rb"
#load "./test.rb"

@data = @data.split(/\n+/).map(&:to_i)
@loops = @data.map do |key|
  current = 1
  counter = 0
  loop do
    current = current * 7
    current = current % 20201227
    counter += 1
    break if current == key
  end
  counter
end

current = 1
@loops[0].times do |time|
    current = current * @data[1]
    current = current % 20201227
end

print "#{current}\n"
#print "#{@loops}\n"
#print "#{@data}\n"

