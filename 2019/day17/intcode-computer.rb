class IntcodeComputer
  HALT = 0
  INPUT = 1
  OUTPUT = 2

  def initialize(memory, inputs=[])
#    @debug = true
    @memory = memory
    @inputs = inputs
    @ip = 0
    @offset = 0
  end

  def log_start()
    if @debug
      print "\e[1;32m[ip:#{@ip.to_s.rjust(4,"0")}] "
      print "\e[0;32mop = #{@op.to_s.rjust(2,"0")} "
      print "{ #{@modes.each_with_index.map { |v,i| "m#{i}=#{v}" }.join(", ")} }"
      print "\e[0m\n"
    end
  end
  
  def log(op, message)
    if @debug
      if op == "GET" or op == "PUT"
        colour = "\e[1;34m"
      else
        colour = "\e[1;31m"
      end

      print "\t#{colour}#{op}: \e[0m#{message}\e[0m\n"
    end
  end

  def decode()
    op = @memory[@ip].to_s.rjust(5, "0")
    @op = op[3..4].to_i
    @modes = [op[2].to_i, op[1].to_i, op[0].to_i]
  end

  def dereference(offset)
    address = @ip + offset
    case @modes[offset-1]
    when 0
      @memory[address]
    when 1
      address
    when 2
      @offset + @memory[address]
    else
      print "Unknown opcode mode\n"
      exit
    end
  end

  def get(offset)
    address = dereference(offset)
    result = @memory[address]
    result = 0 if result.nil? 
    log("GET", "address = #{address}, result = #{result}")
    result
  end

  def put(offset, value)
    address = dereference(offset)
    address = 0 if address.nil?
    @memory[address] = value
    log("PUT", "address = #{address}, value = #{value}")
  end

  def set_input(inputs)
    @inputs = inputs
  end

  def interrupt(state, data=nil)
    [state,data]
  end

  def execute()
    halt = false
    while !halt and @ip < @memory.length
      decode()
      log_start()
      case @op
      when 1
        in1 = get(1)
        in2 = get(2)
        log("ADD", "#{in1} + #{in2} = #{ in1 + in2 }")
        put(3, in1 + in2)
        @ip += 4
      when 2
        in1 = get(1)
        in2 = get(2)
        log("MUL", "#{in1} * #{in2} = #{ in1 * in2 }")
        put(3, in1 * in2)
        @ip += 4
      when 3
        if(@inputs.size == 0)
          log("IN", "No inputs availabile")
          return interrupt(INPUT)
        end
        log("IN", "#{@inputs.first}")
        put(1, @inputs.shift)
        @ip += 2
      when 4
        out = get(1)
        log("OUT", "#{out}")
        @ip += 2
        return interrupt(OUTPUT,out)
      when 5
        in1 = get(1)
        in2 = get(2)
        log("JMP-IF-TRUE", "#{in1} != 0 = #{in1 != 0 ? "true jump to #{in2}" : "false"}")
        @ip = in1 != 0 ? in2 : @ip + 3
      when 6
        in1 = get(1)
        in2 = get(2)
        log("JMP-IF-FALSE", "#{in1} == 0 = #{in1 == 0 ? "true jump to #{in2}" : "false"}")
        @ip = in1 == 0 ? in2 : @ip + 3
      when 7
        in1 = get(1)
        in2 = get(2)
        log("LESS-THAN", "#{in1} < #{in2} = #{ in1 < in2 ? "true" : "false" }")
        put(3, in1 < in2 ? 1 : 0)
        @ip += 4
      when 8
        in1 = get(1)
        in2 = get(2)
        log("EQUAL" , "#{in1} == #{in2} = #{ in1 == in2 ? "true" : "false" }")
        put(3, in1 == in2 ? 1 : 0)
        @ip += 4
      when 9
        change = get(1)
        log("SET-REL-OFFSET", "#{@offset} + #{change} = #{@offset + change}")
        @offset += change
        @ip += 2
      when 99
        halt = true
        log("HALT","done\n")
      else
        # Skip invalid opcodes
        log("INVALID-OPCODE", "skipping")
        @ip += 1
      end
    end
    return interrupt(HALT)
  end
end
