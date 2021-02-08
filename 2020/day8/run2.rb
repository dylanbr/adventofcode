load "./data.rb"
#load "./test.rb"

@data = @data.split(/\n+/).map do |line|
  ops = line.split(/\s+/)
  ops[1] = ops[1].to_i
  ops
end

@targets = []
@data.each_with_index do |line, index|
  if line[0] == "nop" or line[0] == "jmp"
    @targets.push(index)
  end
end

@targets.each do |target|
  @ops = @data.clone
  @ops[target] = @ops[target].clone
  if @ops[target][0] == "nop"
    @ops[target][0] = "jmp"
  else
    @ops[target][0] = "nop"
  end
  @acc = 0
  @ip = 0
  @seen = {}
  @exception = false
  loop do
    if @seen.key? @ip
      @exception = true
      break
    end
    if @ip >= @ops.size
      break
    end
    @seen[@ip] = true
    (op, offset) = @ops[@ip]
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
  if not @exception
    break
  end
end

print "acc = #{@acc}\n\n"
#print "#{@targets}\n\n"
#print "#{@data}\n"
