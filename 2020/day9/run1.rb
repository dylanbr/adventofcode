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
    print "Not found for position #{check} = #{@data[check]}\n"
    exit
  end
  #print "#{options}\n"
  #print "options = #{check-@pre} - #{options} - #{check} - #{@data[check]}\n"
end

#print "#{@data}\n"
