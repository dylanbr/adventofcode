load "./data.rb"
#load "./test.rb"

@data = @data.split(/\n+/).map do |num|
  num.to_i
end

start = @pre
(start..@data.size-1).each do |check|
  options = @data.slice(check-@pre,@pre).combination(2).map do |pair|
    pair.reduce(:+)
  end
  if !options.include? @data[check]
    @target = @data[check]
    break
  end
  #print "#{options}\n"
  #print "options = #{check-@pre} - #{options} - #{check} - #{@data[check]}\n"
end

print "target = #{@target}\n"

(0..@data.size-2).each do |check|
  @sum = 0
  @count = 0
  (check..@data.size-1).each do |pos|
    @sum += @data[pos]
    @count += 1
    if @sum > @target
      break
    end
    if @sum == @target and @count > 1
      list = (check..pos).map do |i|
        @data[i]
      end
      print "#{list.min + list.max}\n"
      exit
    end
  end
end

#print "#{@data}\n"
