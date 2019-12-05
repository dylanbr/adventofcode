require "./data.rb"

#@debug = true

def decode(op)
  op = op.to_s.rjust(5, "0")
  [op[3..4].to_i, [op[2].to_i, op[1].to_i, op[0].to_i]]
end

def get(mode, value)
  if mode == 1
    return value
  else
    return @data[value]
  end
end

def log(ip, message)
  if @debug
    print "[ip #{ip.to_s.rjust(3," ")}, op #{@data[ip].to_s.rjust(5, " ")}] #{message}\n"
  end
end

halt = false
ip = 0
final_output = ""
while !halt and ip < @data.length
  op, modes  = decode(@data[ip])
  case op
  when 1
    in1 = get(modes[0], @data[ip+1])
    in2 = get(modes[1], @data[ip+2])
    out = @data[ip+3]
    @data[out] = in1 + in2
    log(ip, "Adding #{in1} (mode #{modes[0]}, #{@data[ip+1]}) + #{in2} (mode #{modes[1]}, #{@data[ip+2]}) = #{ in1 + in2 } > #{out}")
    ip += 4
  when 2
    in1 = get(modes[0], @data[ip+1])
    in2 = get(modes[1], @data[ip+2])
    out = @data[ip+3]
    @data[out] = in1 * in2
    log(ip, "Multiplying #{in1} (mode #{modes[0]}) * #{in2} (mode #{modes[1]}) = #{ in1 * in2 } > #{out}")
    ip += 4
  when 3
    input = 1
    out = get(modes[0], @data[ip+1])
    @data[out] = input
    log(ip, "Input to #{out} (mode #{modes[0]}, #{ @data[ip+1] }) > #{input}")
    ip += 2
  when 4
    input = @data[ip+1]
    out = @data[input]
    log(ip,"Output from #{input} (mode #{modes[0]}, #{ @data[ip+1] }) > #{out}\n")
    final_output = out 
    ip += 2
  when 99
    halt = true
    log(ip,"Halt")
  else
    # Skip invalid opcodes
    ip += 1
  end
end

print "Final output = #{final_output}\n"
