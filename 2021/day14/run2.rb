load "./data.rb"
#load "./test.rb"

(@template, @rules) = @data.split(/\n\n/)

@rules = @rules.split(/\n/).map do |rule|
  rule.split(" -> ")
end.to_h

@pairs = Hash.new(0)
@template.chars.each_cons(2).each do |pair|
  @pairs[pair.join("")] += 1
end.to_h

(1..40).each do |step|
  @new_pairs = Hash.new(0)
  @pairs.each do |pair, count|
    new_char = @rules[pair]
    (start_char, end_char) = pair.chars
    @new_pairs[start_char + new_char] += count
    @new_pairs[new_char + end_char] += count
  end
  @pairs = @new_pairs
end

@count = Hash.new(0)
@pairs.each do |pair, count|
  (start_char, _) = pair.chars
  @count[start_char] += count
end
@count[@template.chars.last] += 1
@count = @count.values.max - @count.values.min

print "Count = #{@count}\n"
print "Template = #{@template}\n"
print "Rules = #{@rules}\n"
print "Pairs = #{@pairs}\n"


exit



@polymer = @template
(1..40).each do |step|
  print "Step #{step}\n"
  last = nil
  @new_polymer = ""
  @polymer.chars.each do |char|
    if not last.nil?
      pair = last + char
      @new_polymer += last + @rules[pair]
    end
    last = char
  end
  @polymer = @new_polymer + last
end

@count = Hash.new(0)
@polymer.chars.each do |char|
  @count[char] += 1
end

@count = @count.values.max - @count.values.min
print "Count = #{@count}\n"
print "Template = #{@template}/\n"
print "Rules = #{@rules}\n"
