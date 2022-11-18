load "./data.rb"
#load "./test.rb"

@answer = @data.split(/\n+/).map do |calc|
  calc = "(" + calc.gsub(/\s/,"") + ")"
  loop do
    before = calc
    calc = calc.gsub(/(\([^()]+\))/) do |group|
      solved = group
      ["+", "*"].each do |op|
        solved = group.sub(/((\d+)#{"\\" + op}(\d+))/) do |match|
          $2.to_i.send(op,$3.to_i).to_s
        end
        break if solved != group
      end
      next solved
    end.gsub(/\((\d+)\)/,"\\1")
    break if calc == before
  end
  next calc
end

print "#{@answer.map(&:to_i).reduce(:+)}\n"
#print "#{@answer.each { |answer| print "#{answer}\n"}}\n"
