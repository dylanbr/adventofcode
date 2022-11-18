load "./data.rb"
#load "./test.rb"

@data = @data.split(/\n+/).map do |line|
  ops = line.split(/\s+/)
  ops[1] = ops[1].to_i
  ops
end

@acc = 0
@ip = 0
@seen = {}
loop do
  if @seen.key? @ip
    break
  end
  @seen[@ip] = true
  (op, offset) = @data[@ip]
  case op
  when "nop"
    @ip += 1
  when "acc"
    @acc += offset
    @ip += 1
  when "jmp"
    @ip += offset
  end
end

print "acc = #{@acc}\n\n"

#print "#{@data}\n"
