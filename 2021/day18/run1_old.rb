load "./data.rb"
load "./test.rb"
load "./test2.rb"

#@data = "[[[[[9,8],1],2],3],4]"

class Node
  attr_accessor :parent, :children

  def initialize(p=nil)
    @parent = p
    @children = Array.new(2)
    @child = 0
  end

  def add_child(v)
    if @child > 1
      print "Too many children\n"
      exit
    end
    @children[@child] = v
    @child += 1
    v
  end

  def add_child_num(v)
    add_child(v)
  end

  def add_child_node
    add_child(Node.new(self))
  end
end


@sums = @data.split(/\n/)

def decode(str)
  result = Node.new
  curr = result
  str.scan(/\[|\]|\d+/).each do |token|
    case token
    when "["
      curr = curr.add_child_node
    when "]"
      curr = curr.parent
    else # number
      curr.add_child_num(token.to_i)
    end
  end
  result
end

def tree_explode(root)
  print "explode\n"
  curr = root.children[0]
  child = 0
  path = []
  level = 1
  #print "["
  loop do
#    print "Level = #{level}, path = #{path}\n"
    if child < 2
      if curr.children[child].is_a? Node
        print "["
        path.push child
        curr = curr.children[child]
        child = 0
        level += 1
        if level >= 4 and curr.children[0].is_a? Integer and curr.children[1].is_a? Integer
          pair = curr.children.dup
          curr = curr.parent
          child = path.pop
          if child == 0
            curr.children[0] = 0
            if curr.children[1].is_a? Integer
              curr.children[1] += pair[1]
            end
          else
            curr.children[1] = 0
            if curr.children[0].is_a? Integer
              curr.children[0] += pair[0]
            end
          end
          print "\n"
          return true
        end
      else
        print "#{curr.children[child]} "
        child += 1
      end
    else
      if path.empty? 
        break
      end
      print "]"
      curr = curr.parent
      child = path.pop
      child += 1
      level -= 1
    end 
  end
  print "\n"
  return false
end

def tree_split(root)
  print "split\n"
  curr = root.children[0]
  child = 0
  path = []
  level = 0
  #print "["
  loop do
#    print "Level = #{level}, path = #{path}\n"
    if child < 2
      if curr.children[child].is_a? Node
        print "["
        path.push child
        curr = curr.children[child]
        child = 0
        level += 1
      else
#        print "Curr[#{child}] = #{curr.children[child]}\n"
        if curr.children[child] >= 10
          val = curr.children[child].to_f
          left = (val / 2).floor
          right = (val / 2).round
          node = Node.new(curr)
          node.add_child_num left
          node.add_child_num right
          curr.children[child] = node
          return true
        end
        print "#{curr.children[child]} "
        child += 1
      end
    else
      if path.empty? 
        break
      end
      print "]"
      curr = curr.parent
      child = path.pop
      child += 1
      level -= 1
    end 
  end
  print "\n"
  return false
end

root = nil
loop do
  break if @sums.empty?
  sum = decode(@sums.shift)
  if root.nil?
    root = sum
  else
    print "merge\n"
    new_root = Node.new
    new_root.children[0] = Node.new(new_root)
    new_root.children[0].children[0] = root.children[0]
    new_root.children[0].children[1] = sum.children[0]
    root.children[0].parent = new_root.children[0]
    sum.children[0].parent = new_root.children[0]
    root = new_root
  end
  done = false
  loop do
    break if done
    done = true
    loop do 
      if tree_explode(root)
        done = false
      else
        break
      end
    end
    if tree_split(root)
      done = false
    end
  end
  print "final\n"
  tree_explode(root)
end

#print @sums
