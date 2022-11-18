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
  attr_reader :tail

  def initialize
    @head = nil
    @tail = nil
  end

  def append(value)
    node = Node.new(value)
    if @head.nil?
      @head = node
      @tail = node
    else
      @tail.next = node
      @tail = node
    end
    node
  end

  def find(value,node=@head)
    current = node
    loop do
      break if current.value == value
      current = current.next
    end
    current
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
