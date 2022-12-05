start = 1
times = 5

start = 3113322113
times = 50

count = 0

current = (start.to_s + " ").split("")
loop do
  new = []
  last = nil
  last_count = 0
  current.each do |digit|
    if last != digit
      if last != nil
        new << last_count.to_s << last.to_s
      end
      last = digit
      last_count = 1
    else
      last_count += 1
    end
  end
  new << " "
  current = new
  count += 1
  print "time = #{count}, length = #{current.length-1}\n"
  break if count >= times
end
print "Final answer length = #{current.length-1}\n"
#print "Final answer = #{current}\n"
