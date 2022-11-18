load "./data.rb"
#load "./test2.rb"

def build_balanced(one, two, times)
  matches = []
  (1..times).each do |count|
    matches.push("(#{one}){#{count}}(#{two}){#{count}}")
  end
  "(#{matches.join("|")})"
end

def make_regex(rule)
  if @rules[rule].is_a? String
    return @rules[rule]
  else
    return "(" + @rules[rule].map do |alternative|
      alternative.map do |target|
        if target == 8
          "(#{make_regex(42)})+"
        elsif target == 11
          #build_balanced(make_regex(42), make_regex(31), 4)
          "(?<r11>#{make_regex(42)}(?:\\g<r11>)?#{make_regex(31)})"
        else
          make_regex(target)
        end
      end.join("")
    end.join("|") + ")"
  end
end

@rules, @messages = @data.split(/\n\n/)

#overrides
#8: 42 | 42 8
#11: 42 31 | 42 11 31
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
count = 0
@messages.each do |message|
  if message.match? regex
    count += 1
  end
end

print "Found #{@messages.size} of which #{count} match\n"

#print "Rule0 = #{make_regex(0)}\n"
#print "Rules = #{@rules}\n"
#print "Messages = #{@messages}\n"
# ex: (a((aa)|(bb)(ab)|(ba))|((ab)|(ba)(aa)|(bb))b)
# ex: (a((aa)|(bb)(ab)|(ba))|((ab)|(ba)(aa)|(bb))b)

#3: ab|ba
#2: aa|bb
#1: (aa|bb)(ab|ba)|(ab|ba)(aa|bb)
#0: a(aa|bb)(ab|ba)|(ab|ba)(aa|bb)b

# 361 too high
# 286 too low
