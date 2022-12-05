load "./data.rb"

#@data = "ugknbfddgicrmopn"
#@data = "haegwjzuvuyypxyu"
#@data = "jchzalrnumimnmhp"
@data = @data.split("\n").reduce(0) { |total, string|
  double = false
  last = ""
  vowels = string.split("").reduce(0) { |count, char|
    if last == char
      double = true
    end
    last = char
    count += 1 if "aeiou".include? char
    count
  }
  disallowed = ["ab", "cd", "pq", "xy"].any? { |check| string.include?(check) }
#  print "vowels = #{vowels}\n"
#  print "double = #{double ? "yes" : "no"}\n"
#  print "disallowed = #{disallowed ? "yes" : "no"}\n"
  if vowels >= 3 and double and not disallowed
    total += 1
  end
  total
}

print "Total = #{@data}\n"
