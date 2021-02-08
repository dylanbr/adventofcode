load "./data.rb"
#load "./test.rb"

load "./list.rb"

@data = @data.chomp.split("").map(&:to_i)

@cup_times = 10000000
@cup_max = 1000000
@cups = {}
first = nil
last = nil
@data.chain((@data.max+1..@cup_max)).each_cons(2) do |cup_pair|
  if first.nil?
    first = cup_pair[0]
  end
  @cups[cup_pair[0]] = cup_pair[1]
  last = cup_pair[1]
end
@cups[last] = first

print "Generation done\n"

current = first
@cup_times.times do |time|
  #print "[#{time+1}] BEFORE = #{@cups}\n"
  taken = @cups[current]
  taken_values = [taken, @cups[taken], @cups[@cups[taken]]]
  target = current
  loop do
    target -= 1
    if target < 1
      target = @cup_max
    end
    break if not taken_values.include?(target)
  end
  #print "#{time+1}: current=#{current}, target=#{target}, taken=#{taken_values}\n"
  @cups[current] = @cups[taken_values[2]]
  @cups[taken_values[2]] = @cups[target]
  @cups[target] = taken
  current = @cups[current]
  #print "[#{time+1}] AFTER = #{@cups}\n\n"
end

print "Answer = #{@cups[1]} * #{@cups[@cups[1]]} = #{@cups[1] * @cups[@cups[1]]}\n"
