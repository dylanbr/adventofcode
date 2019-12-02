require "./data.rb"

#@data = [1,0,0,0,99]
#@data = [2,3,0,3,99]

@data[1] = 12
@data[2] = 2

ip = 0
max = @data.size
while ip >= 0 and ip < max
  op = @data[ip]
  in1 = @data[ip+1]
  in2  = @data[ip+2]
  out = @data[ip+3]
  case op
  when 99
    break
  when 1
    @data[out] = @data[in1] + @data[in2]
  when 2
    @data[out] = @data[in1] * @data[in2]
  else
    abort("Unknown instruction: " + op.to_s)
  end
  ip += 4
end

print @data[0].to_s + "\n"
