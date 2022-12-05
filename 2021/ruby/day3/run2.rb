load "./data.rb"
#load "./test.rb"

@data = @data.split(/\n/).map do |row|
  row.split("").map(&:to_i)
end

def calc(input, type=1)
  result = input.dup()
  pos = 0
  while result.size > 1 do
    if result.map { |row| row[pos] }.sum >= result.size.fdiv(2).ceil
      keep = type
    else
      keep = (type + 1) % 2
    end

    result.filter! do |row|
      true if row[pos] == keep
    end
    pos += 1
  end
  result[0].map(&:to_s).join.to_i(2)
end

oxygen = calc(@data)
co2 = calc(@data,0)

print "Oxygen = #{oxygen}, CO2 = #{co2}, answer = #{oxygen * co2}\n"
