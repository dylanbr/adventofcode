load "./data.rb"
#load "./test.rb"
#load "./test2.rb"

@data = @data.split(/\n+/).map(&:to_i).sort.unshift(0).push(nil).each_cons(2).map { |pair|
  next 3 if pair[1].nil?
  pair[1] - pair[0]
}.slice_before { |diff| 
  diff == 3
}.map { |runs|
  run = runs.count(1)
  run * (run-1) / 2 + 1
}.reduce(:*)

print "Answer = #{@data}\n"

#exit
#
#@runs = []
#found = false
#count = 0
#@data.each do |diff|
#  if not found and diff == 1
#    found = true
#  end
#  if found and diff != 1
#    found = false
#    if count > 1
#      @runs.push(count)
#    end
#    count = 0
#  end
#  if found
#    count += 1
#  end
#end
#
#@combos = @runs.map do |run|
#  case run
#  when 2
#    2
#  when 3
#    4
#  when 4
#    7
#  end
#end
#
#print "#{@data}\n"
#print "#{@runs}\n"
#print "#{@combos}\n"
#print "Answer = #{@combos.reduce(:*)}\n"
