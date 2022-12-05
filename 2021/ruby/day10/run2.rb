load "./data.rb"
#load "./test.rb"

points = @data.split(/\n/).map { |s| s.split("") }.map do |line|
  opened = []
  score = line.reduce(0) do | _, item|
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

  next nil if score > 0
  opened.reverse.reduce(0) do |total, item|
    (total * 5) + case item
                  when ")" then 1
                  when "]" then 2
                  when "}" then 3
                  when ">" then 4
                  end
  end
end.reject(&:nil?).sort

print "Points = #{points[points.size/2]}\n"
exit

@chars = {
  '(' => ['(',')',3,1],
  '[' => ['[',']',57,2],
  '{' => ['{','}',1197,3],
  '<' => ['<','>',25137,4]
}

@closing = {
  ')' => '(',
  ']' => '[',
  '}' => '{',
  '>' => '<'
}

points = []
@data = @data.split(/\n/).map { |s| s.split("") }.filter do |line|
  opened = []
  valid = true
  line.each do |item|
    if @chars.keys.include? item
      opened.push item
    else
      if opened.empty?
        valid = false
        break
      elsif @chars[opened.last][1] == item
        opened.pop
      else
        valid = false
        break
      end
    end
  end
  if valid
    value = opened.reverse.map do |item|
      @chars[item][3]
    end.reduce(0) do |total, item|
      total = (total * 5) + item
    end
    points.push value
  end
  valid
end

points = points.sort[points.size / 2]

#print @data
print "Points = #{points}\n"
