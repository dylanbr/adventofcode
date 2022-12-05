load "./data.rb"
#load "./test.rb"

class String
  def is_number?
    to_i.to_s == to_s
  end
end

class ALU
  attr_accessor :regs

  def initialize(code)
    @code = code
    reset
  end

  def reset
    @regs = { 'w'=>0, 'x'=>0, 'y'=>0, 'z'=>0 }
  end

  def set_input(inp, default=0)
    @input = inp
  end

  def input
#    print "  iregs(#{@input.first} = #{@regs}\n"
    @input.shift
  end

  def value(v)
    if v.is_a? Integer
      v
    else
      @regs[v]
    end
  end

  def run
    reset
    @code.each do |(op,args)|
      case op
      when "inp"
        @regs[args[0]] = input
      when "add"
        @regs[args[0]] = @regs[args[0]] + value(args[1])
      when "mul"
        @regs[args[0]] = @regs[args[0]] * value(args[1])
      when "div"
        v = value(args[1])
        if v == 0
          return false
        end
        @regs[args[0]] = @regs[args[0]] / value(args[1])
      when "mod"
        v = value(args[1])
        if @regs[args[0]] < 0 or v <= 0
          return false
        end
        @regs[args[0]] = @regs[args[0]] % value(args[1])
      when "eql"
        if @regs[args[0]] == value(args[1])
          @regs[args[0]] = 1
        else
          @regs[args[0]] = 0
        end
      else 
        print "Unknown OP #{op}\n"
        return false
      end      
    end
    return true
  end
end

@data = @data.split(/\n/).map do |command|
  op, *args = *command.split(/\s+/)
  [op, args.map do |arg|
    if arg.is_number?
      arg.to_i
    else
      arg
    end
  end] 
end

@pairs = [
  [9,7],[1],[5,1],[1,9],[1,9],[9,5],[9],[1,4],[1,3],[7,9],[6,9],[3,1],[9,5],[5,1]
]
(a, *b) = *@pairs
@numbers = a.product(*b)
# [0]  9 or 7
# [1]  1
# [2]  5 or 1
# [3]  1 or 9
# [4]  1 or 9
# [5]  9 or 5
# [6]  9
# [7]  1 or 4
# [8]  1 or 3
# [9]  7 or 9
# [10] 6 or 9
# [11] 3 or 1
# [12] 9 or 5
# [13] 5 or 1
alu = ALU.new(@data)
@found = []
@numbers.each do |number|
  alu.set_input(number.dup)
#  print "Trying number #{number.join("")}\n"
  if alu.run
    if alu.regs['z'] == 0
      @found.push(number.join("").to_i)
    end
  else
    print "fail\n"
  end
end
print "Smallest = #{@found.min}\n"
