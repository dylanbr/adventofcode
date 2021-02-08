load "./data.rb"
#load "./test.rb"

def mid(range)
  ((range.min + range.max) / 2)
end

@data = @data.split(/\n+/).map do |seat|
  seat.split("").reduce([0..127,0..7]) do |ranges, char|
    case char
    when "F"
      ranges[0] = ranges[0].min..mid(ranges[0]).floor
    when "B"
      ranges[0] = mid(ranges[0]).ceil..ranges[0].max
    when "L"
      ranges[1] = ranges[1].min..mid(ranges[1]).floor
    when "R"
      ranges[1] = mid(ranges[1]).ceil..ranges[1].max
    end
    ranges
  end.map do |range|
    range.max
  end
end.map do |seat|
  seat[0] * 8 + seat[1]
end.sort

@data.each_with_index do |value, index|
  if @data[index+1] != (value + 1) and index != @data.size-1
    print "Seat id is #{value + 1}\n"
  end
end
