load "./data.rb"
#load "./test.rb"

(@template, @rules) = @data.split(/\n\n/)

@rules = @rules.split(/\n/).map do |rule|
  rule.split(" -> ")
end.to_h

@polymer = @template
(1..10).each do |step|
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
#print "Template = #{@template}/\n"
#print "Rules = #{@rules}\n"
