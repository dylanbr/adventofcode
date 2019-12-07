require "./data.rb"

#@debug = true

def decode(op)
  op = op.to_s.rjust(5, "0")
  [op[3..4].to_i, [op[2].to_i, op[1].to_i, op[0].to_i]]
end

def get(memory, mode, value)
  if mode == 1
    return value
  else
    return memory[value]
  end
end

def log(ip, message)
  if @debug
    print "[ip #{ip.to_s.rjust(3," ")}, op #{@data[ip].to_s.rjust(5, " ")}] #{message}\n"
  end
end

def cpu(memory,inputs)
  halt = false
  ip = 0
  outputs = []
  input = 0
  while !halt and ip < memory.length
  #  print "OP = #{ memory[ip] } - "
    op, modes  = decode(memory[ip])
    case op
    when 1
      in1 = get(memory,modes[0], memory[ip+1])
      in2 = get(memory,modes[1], memory[ip+2])
      out = memory[ip+3]
      memory[out] = in1 + in2
      log(ip, "Adding #{in1} (mode #{modes[0]}, #{memory[ip+1]}) + #{in2} (mode #{modes[1]}, #{memory[ip+2]}) = #{ in1 + in2 } > #{out}")
      ip += 4
    when 2
      in1 = get(memory,modes[0], memory[ip+1])
      in2 = get(memory,modes[1], memory[ip+2])
      out = memory[ip+3]
      memory[out] = in1 * in2
      log(ip, "Multiplying #{in1} (mode #{modes[0]}) * #{in2} (mode #{modes[1]}) = #{ in1 * in2 } > #{out}")
      ip += 4
    when 3
      out = memory[ip+1]
      memory[out] = inputs[input]
      log(ip, "Input to #{out} (mode #{modes[0]}, #{ memory[ip+1] }) > #{inputs[input]} (Input ##{input})")
      input += 1
#      input = 0 if input >= inputs.size - 1
      ip += 2
    when 4
      out = get(memory,modes[0],memory[ip+1])
      log(ip,"Output from #{input} (mode #{modes[0]}, #{ memory[ip+1] }) > #{out} (Output ##{outputs.length+1})")
      outputs.push(out)
      ip += 2
    when 5
      in1 = get(memory,modes[0], memory[ip+1])
      in2 = get(memory,modes[1], memory[ip+2])
      log(ip,"Jump-if-true if #{in1} is non-zero > #{in2}")
      if(in1 != 0)
        ip = in2
      else
        ip += 3
      end
    when 6
      in1 = get(memory,modes[0], memory[ip+1])
      in2 = get(memory,modes[1], memory[ip+2])
      log(ip,"Jump-if-false if #{in1} is zero > #{in2}")
      if(in1 == 0)
        ip = in2
      else
        ip += 3
      end
    when 7
      in1 = get(memory,modes[0], memory[ip+1])
      in2 = get(memory,modes[1], memory[ip+2])
      out = memory[ip+3]
      log(ip,"Less than #{in1} < #{in2} to #{out} > #{ in1 < in2 ? "1" : "0" }")
      if(in1 < in2)
        memory[out] = 1
      else
        memory[out] = 0
      end
      ip += 4
    when 8
      in1 = get(memory,modes[0], memory[ip+1])
      in2 = get(memory,modes[1], memory[ip+2])
      out = memory[ip+3]
      log(ip,"Equals #{in1} (#{modes[0]}, #{memory[ip+1]}) = #{in2} (#{modes[1]}, #{memory[ip+2]}) to #{out} > #{ in1 == in2 ? "1" : "0" }")
      if(in1 == in2)
        memory[out] = 1
      else
        memory[out] = 0
      end
      ip += 4
    when 99
      halt = true
      log(ip,"Halt\n")
    else
      # Skip invalid opcodes
      ip += 1
    end
  end
  outputs
end

# Test 1
#phases = [4,3,2,1,0]

# Test 2
#phases = [0,1,2,3,4]

# Test 3
#phases = [1,0,4,3,2]

phases = (0..4).to_a.permutation(5).to_a
highest = 0
for p in phases
  output = 0
  for i in 0..4
    phase = p[i]
    output = cpu(@data.dup,[phase, output])[0]
  end
  highest = output if output > highest
end

print "Highest = #{highest}\n"
