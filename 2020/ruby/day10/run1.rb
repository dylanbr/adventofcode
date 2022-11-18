load "./data.rb"
#load "./test.rb"
#load "./test2.rb"

@answer = @data.split(/\n+/).map(&:to_i).sort.unshift(0).push(nil).each_cons(2).map { |pair|
  next 3 if pair[1].nil?
  pair[1] - pair[0]
}.reduce(Hash.new(0)) { |list, diff|
  list[diff] += 1
  list
}.values.reduce(:*)

print "Answer = #{@answer}\n"
