load "./data.rb"
#load "./test.rb"

load "./list.rb"

@data = @data.chomp.split("").map(&:to_i)

@cup_max = 1000000
@cup_values = {}
@cups = List.new
@data.each do |cup|
  new_node = @cups.append(cup)
  @cup_values[cup] = new_node
end
(@data.max+1..@cup_max).each do |cup|
  new_node = @cups.append(cup)
  @cup_values[cup] = new_node
end
@cups.tail.next = @cups.head

current = @cups.head
10000000.times do |time|
  #print "[#{time+1}] BEFORE = "
  #print_nodes(@cups.head)
  taken = current.next
  current.next = taken.next.next.next
  taken_values = [taken.value, taken.next.value, taken.next.next.value]
  target = current.value
  #print "  START TARGET = #{target}\n"
  destination = nil?
  loop do
    target -= 1
    if target < 1
      target = @cup_max
    end
    next if taken_values.include? target
    destination = @cup_values[target]
    break
  end
  #print "#{time+1}: current=#{current}, target=#{target}, dest=#{destination}, taken=#{taken_values}\n"
  taken.next.next.next = destination.next
  destination.next = taken
  current = current.next
  #print "[#{time+1}] AFTER = "
  #print_nodes(@cups.head)
  #if (time % 10) == 0
    #print "#{time+1}: current=#{current}, target=#{target}, dest=#{destination}, taken=#{taken_values}\n"
  #  print "Round #{time}\r"
  #end
end
print "Done\n"
first_cup = @cups.find(1)
print "Answer = #{first_cup.next.value} * #{first_cup.next.next.value} = #{first_cup.next.value * first_cup.next.next.value}\n"
#@cups_arr.shift
#print "Answer = #{@cups_arr.join("")}\n"
#print "Done\n"
