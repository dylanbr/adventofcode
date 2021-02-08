load "./data.rb"
#load "./test.rb"
#load "./test2.rb"

class String
    def is_i?
       !!(self =~ /\A[0-9]+\z/)
    end
end

@data = @data.split(/\n\n/).map do |line|
  line.split(/\n|\s+/).map do |field|
    field.split(/:/)
  end.to_h
end

rules = {
  "byr" => {"digits" => 4, "min" => 1920, "max" => 2002},
  "iyr" => {"digits" => 4, "min" => 2010, "max" => 2020},
  "eyr" => {"digits" => 4, "min" => 2020, "max" => 2030},
  "hgt" => {},
  "hcl" => {},
  "ecl" => {"options" => ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]},
  "pid" => {"digits" => 9}
}

valid = 0
@data.each do |line|
  if (rules.keys - line.keys).size != 0
    next
  end
  is_valid = true
  rules.each do |key, rule| 
    if rule.has_key? "digits" and (not line[key].is_i? or line[key].size != rule["digits"])
      is_valid = false
    end
    if rule.has_key? "min" and line[key].to_i < rule["min"]
      is_valid = false
    end
    if rule.has_key? "max" and line[key].to_i > rule["max"]
      is_valid = false
    end
    if rule.has_key? "options" and not rule["options"].include?(line[key])
      is_valid = false
    end
    if key == "hcl" and not line[key].match(/#[0-9a-f]{6}/)
      is_valid = false
    end
    if key == "hgt"
      height = line[key].scan(/(\d+)(cm|in)/)[0]
      if height.nil? or 
        height.size != 2 or
        (height[1] != "cm" and height[1] != "in") or
        (height[1] == "cm" and height[0].to_i < 150) or (height[1] == "cm" and height[0].to_i > 193) or
        (height[1] == "in" and height[0].to_i < 59) or (height[1] == "in" and height[0].to_i > 76)
        is_valid = false
      end
    end
  end
  if is_valid
    valid += 1
  end
end

#print "#{@data}\n"
print "Found #{valid} valids\n"
