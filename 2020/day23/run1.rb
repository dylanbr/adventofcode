load "./data.rb"
#load "./test.rb"

@data = @data.chomp.split("").map(&:to_i)

class Node
  attr_accessor :value
  attr_accessor :next

  def initialize(value)
    @value = value
    @next = nil
  end
  
  def tail?
    @next.nil?
  end
end

class List
  attr_reader :head

  def initialize
    @head = nil
  end

  def empty?
    @head.nil?
  end

  def append(value)
    node = Node.new(value)
    if empty?
      @head = node
    else
      last(head).next = node
    end
  end

  def last(node=@head)
    return node if node.tail?
    last(node.next)
  end

  def find(value,node=@head)
    return node if node.value == value
    find(value,node.next)
  end
end

def print_nodes(start)
  current = start
  loop do
    print "#{current.value}"
    current = current.next
    break if current == start
    print ","
  end
  print "\n"
end

def get_nodes(start)
  current = start
  values = []
  loop do
    values.push(current.value)
    current = current.next
    break if current == start
  end
  values
end

@cups = List.new
@data.each do |cup|
  @cups.append(cup)
end
@cups.last.next = @cups.head

max = @data.max
print "MAX = #{@data.max}\n"
current = @cups.head
100.times do |time|
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
      target = max
    end
    next if taken_values.include? target
    destination = @cups.find(target)
    break
  end
  #print "#{time+1}: current=#{current}, target=#{target}, dest=#{destination}, taken=#{taken_values}\n"
  taken.next.next.next = destination.next
  destination.next = taken
  current = current.next
  #print "[#{time+1}] AFTER = "
  #print_nodes(@cups.head)
end

@cups_arr = get_nodes(@cups.find(1))
@cups_arr.shift
print "Answer = #{@cups_arr.join("")}\n"



#100.times do |time|
#  #print "#{time+1}: BEFORE=#{@cups}\n"
#  current = @cups[0]
#  taken = @cups.slice!(1,3)
#  target = current
#  destination = nil
#  loop do
#    target -= 1
#    if target < 1
#      target = 9
#    end
#    destination = @cups.index(target)
#    break if not destination.nil?
#  end
#  @cups.insert(destination+1,*taken)
#  @cups.rotate!(1)
#  #print "#{time+1}: current=#{current}, target=#{target}, dest=#{destination}, taken=#{taken}\n"
#  #print "#{time+1}: AFTER=#{@cups.rotate(-rotations)}\n"
#end
#loop do
#  break if @cups[0] == 1
#  @cups.rotate!(1)
#end
#@cups.shift

#print "Answer = #{@cups.join("")}\n"
#print "#{@data}\n"
