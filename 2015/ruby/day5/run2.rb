load "./data.rb"

#@data = "ugknbfddgicrmopn"
#@data = "haegwjzuvuyypxyu"
#@data = "jchzalrnumimnmhp"
#@data = "qjhvhtzxzqqjkmpb"
#@data = "xxyxx"
#@data = "uurcxstgmygtbstg"
#@data = "ieodomkazucvgmuy"
@data = @data.split("\n").reduce(0) { |total, string|
  singlepair = /(.).\1/.match?(string)
  doublepair = /(..).*\1/.match?(string)
  if singlepair and doublepair
    total += 1
  end
  total
}

print "Total = #{@data}\n"
