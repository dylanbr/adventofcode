require "./data.rb"

def cpu(initial_data, preset1, preset2)
  data = initial_data.dup
  data[1] = preset1
  data[2] = preset2
  ip = 0
  max = data.size
  while ip >= 0 and ip < max
    op = data[ip]
    in1 = data[ip+1]
    in2  = data[ip+2]
    out = data[ip+3]
    case op
    when 99
      break
    when 1
      data[out] = data[in1] + data[in2]
    when 2
      data[out] = data[in1] * data[in2]
    else
      abort("Unknown instruction: " + op.to_s)
    end
    ip += 4
  end
  data[0]
end

for noun in 0..99 do
  for verb in 0..99 do
    #print "noun = " + noun.to_s + ", verb = " + verb.to_s + ", result = " + cpu(@data,noun,verb).to_s + "\n"
    if cpu(@data,noun,verb) == 19690720
      print "Found 19690720 where noun = " + noun.to_s + " and verb = " + verb.to_s + "\n"
      print "Answer = " + (100 * noun + verb).to_s + "\n"
    end
  end
end
#print cpu(@data)[0].to_s + "\n"
