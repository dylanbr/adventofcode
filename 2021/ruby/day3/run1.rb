load "./data.rb"
#load "./test.rb"

@data = @data.split(/\n/).map do |row|
  row.split("").map(&:to_i)
end

half = @data.size / 2
gamma = @data.transpose.map(&:sum).map do |bits|
  next "1" if bits > half
  "0"
end.join("").to_i(2)
epsilon = gamma ^ ("1" * @data[0].size).to_i(2)

print "Gamme = #{gamma}, epsilon = #{epsilon}, answer = #{gamma * epsilon}\n"
