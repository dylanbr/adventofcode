load "./data.rb"
#load "./test.rb"

@data = @data.split(/\n\n/).map do |line|
  line.split(/\n|\s+/).map do |field|
    field.split(/:/)
  end.to_h
end

required = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"];
valid = 0
@data.each do |line|
  if (required - line.keys).size == 0
    valid += 1
  end
end

#print "#{@data}\n"
print "Found #{valid} valids\n"
