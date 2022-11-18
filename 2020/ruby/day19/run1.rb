load "./data.rb"
#load "./test.rb"

def make_regex(rule)
  if @rules[rule].is_a? String
    return @rules[rule]
  else
    return "(" + @rules[rule].map do |alternative|
      alternative.map do |target|
        make_regex(target)
      end.join("")
    end.join("|") + ")"
  end
end

@rules, @messages = @data.split(/\n\n/)

@rules = @rules.split(/\n+/).map do |rule|
  rule = rule.split(/: /)
  rule[0] = rule[0].to_i
  if rule[1][0] == "\""
    rule[1] = rule[1][1]
  else
    rule[1] = rule[1].split(/ \| /).map do |alternative|
      alternative.split(/\s+/).map(&:to_i)
    end
  end
  rule
end.to_h

@messages = @messages.split(/\n+/)

regex = Regexp.new("^" + make_regex(0) + "$")
print "#{regex}\n"
print "#{Regexp.new("^abc$")}\n"
count = 0
@messages.each do |message|
  print "Checking message '#{message}': "
  if message.match? regex
    print "yes"
    count += 1
  else
    print "no"
  end
  print "\n"
end

print "Found #{@messages.size} of which #{count} match\n"

print "Rule0 = #{make_regex(0)}\n"

#print "Rules = #{@rules}\n"
#print "Messages = #{@messages}\n"
# ex: (a((aa)|(bb)(ab)|(ba))|((ab)|(ba)(aa)|(bb))b)
# ex: (a((aa)|(bb)(ab)|(ba))|((ab)|(ba)(aa)|(bb))b)

#3: ab|ba
#2: aa|bb
#1: (aa|bb)(ab|ba)|(ab|ba)(aa|bb)
#0: a(aa|bb)(ab|ba)|(ab|ba)(aa|bb)b
