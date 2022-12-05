load "./data.rb"
#load "./test.rb"

points = @data.split(/\n/).map { |s| s.split("") }.map do |line|
  opened = []
  line.reduce(0) do | _, item|
    if %w"( [ { <".include? item
      opened.push case item
                  when "(" then ")"
                  when "[" then "]"
                  when "{" then  "}"
                  when "<" then ">"
                  end
    else
      if item == opened.last
        opened.pop
      else
        break case item
                     when ")" then 3
                     when "]" then 57
                     when "}" then 1197
                     when ">" then 25137
                     end
      end
    end
    next 0
  end
end.sum

print "Points = #{points}\n"
exit

@chars = {
  '(' => ['(',')',3],
  '[' => ['[',']',57],
  '{' => ['{','}',1197],
  '<' => ['<','>',25137]
}

@closing = {
  ')' => '(',
  ']' => '[',
  '}' => '{',
  '>' => '<'
}

points = 0
@data = @data.split(/\n/).map { |s| s.split("") }.filter do |line|
  opened = []
  valid = true
  line.each do |item|
    if @chars.keys.include? item
      opened.push item
    else
      if opened.empty?
        valid = false
        points += @chars[@closing[item]][2]
        break
      elsif @chars[opened.last][1] == item
        opened.pop
      else
        valid = false
        points += @chars[@closing[item]][2]
        break
      end
    end
  end
  valid
end

#print @data
print "Points = #{points}\n"
