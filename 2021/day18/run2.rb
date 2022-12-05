load "./data.rb"
#load "./test.rb"
#load "./test2.rb"

class Node
  attr_accessor :parent, :left, :right

  def initialize(p=nil,values=[])
    @parent = p
    @child = 0
    values.each do |value|
      num(value)
    end
  end

  def val(v)
    if @child > 1
      print "ERROR: Too many children\n"
      exit
    end
    if v.is_a? Node
      v.parent = self
    end
    if @child == 0
      @child += 1
      @left = v
    else
      @child += 1
      @right = v
    end
  end

  def num(v)
    val(v)   
  end

  def pair
    val(Node.new(self))
  end

  def to_s
    "[ #{@left.to_s}, #{@right.to_s} ]"
  end

  def +(node)
    Node.new(nil, [self, node])
  end

  def first_left(node,pos,add)
    if pos == 2 and not node.left.is_a? Node
      node.left += add
      return node.left
    elsif pos == 2 and node.left.is_a? Node
      curr = node.left
    else
      curr = node
      loop do
        last = curr
        curr = curr.parent
        break if curr.nil? or curr.right == last
      end
      if curr.nil?
        return nil
      end
      if not curr.left.is_a? Node
        curr.left += add
        return curr.left
      end
      curr = curr.left
    end
    child = 1
    chain = []
    loop do
      if child > 0
        if child == 1
          value = curr.right
        else
          value = curr.left
        end
        if value.is_a? Node
          chain.push child
          curr = value
          child = 1
        else
          if child == 1
            curr.right += add
          else
            curr.left += add
          end
          return curr
        end
      else
        break if chain.empty?
        curr = curr.parent
        child = chain.pop - 1
      end
    end
    return nil
  end

  def first_right(node,pos,add=0)
    if pos == 1 and not node.right.is_a? Node
      node.right += add
      return node.right
    elsif pos == 1 and node.right.is_a? Node
      curr = node.right
    else
      curr = node
      loop do
        last = curr
        curr = curr.parent
        break if curr.nil? or curr.left == last
      end
      if curr.nil?
        return nil
      end
      if not curr.right.is_a? Node
        curr.right += add
        return curr.right
      end
      curr = curr.right
    end
    child = 0
    chain = []
    loop do
      if child < 2
        if child == 1
          value = curr.right
        else
          value = curr.left
        end
        if value.is_a? Node
          chain.push child
          curr = value
          child = 0
        else
          if child == 1
            curr.right += add
          else
            curr.left += add
          end
          return curr
        end
      else
        break if chain.empty?
        curr = curr.parent
        child = chain.pop + 1
      end
    end
    return nil
  end

  def explode
    print "In explode\n"
    node = self
    child = 0
    chain = []
    level = 0
    loop do
      if child < 2
        if child == 0
          value = node.left
        else
          value = node.right
        end
        if value.is_a? Node
          chain.push child
          node = value
          child = 0
          level += 1
          if level == 4
            left = node.left
            right = node.right
            node = node.parent
            child = chain.pop
            if child == 0
              node.left = 0
              pos = 1
            else
              node.right = 0
              pos = 2
            end
            first_left(node,pos,left)
            first_right(node,pos,right)
#            print "First left = #{first_left(node,pos)}, First right = #{first_right(node,pos)} for explode (#{left},#{right})\n"
            return true
          end
        else
          child += 1
        end
      else
        break if chain.empty?
        node = node.parent
        child = chain.pop + 1
        level -= 1
      end
    end
    return false
  end

  def split
    print "In split\n"
    node = self
    child = 0
    chain = []
    loop do
      if child < 2
        if child == 0
          value = node.left
        else
          value = node.right
        end
        if value.is_a? Node
          chain.push child
          node = value
          child = 0
        else
          if value >= 10
            value = value.to_f
            left = (value / 2).floor
            right = (value / 2).round
            new_node = Node.new(node, [left, right])
            if child == 0
              node.left = new_node
            else
              node.right = new_node
            end
            return true
          end
          child += 1
        end
      else
        break if chain.empty?
        node = node.parent
        child = chain.pop + 1
      end
    end
    return false
  end

  def reduce
    print "In reduce\n"
    loop do
      found = false
      loop do
        break if not explode
        found = true
      end
      loop do 
        break if not split
        found = true
        break
      end
      break if not found
    end
    self
  end

  def magnitude
    total = 0
    if @left.is_a? Node
      value = @left.magnitude
    else
      value = @left
    end

    total += value * 3
    if @right.is_a? Node
      value = @right.magnitude
    else
      value = @right
    end
    total += value * 2
    
    return total
  end
end

def decode(str)
  result = Node.new
  first = true
  curr = result
  str.scan(/\[|\]|\d+/).each do |token|
    case token
    when "["
      if not first
        curr = curr.pair
      else
        first = false
      end
    when "]"
      curr = curr.parent
    else # number
      curr.num(token.to_i)
    end
  end
  result
end

#a = decode("[[1,2],1]")
#b = decode("[[12,[9,[8,1]]],2]")
#print "a = #{a.to_s}, b = #{b.to_s}\n"
#print "sum = #{(a+b).reduce.to_s}\n"
#exit

@sums = @data.split(/\n/)
@pairs = (0..@sums.size-1).to_a.permutation(2).to_a
@max = 0
@pairs.each do |pair|
  (a,b) = pair
  magnitude = (decode(@sums[a]) + decode(@sums[b])).reduce.magnitude
  if magnitude > @max
    @max = magnitude
  end
end
print "Max = #{@max}\n"
