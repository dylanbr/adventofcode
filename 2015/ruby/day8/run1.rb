load "./data.rb"

#@data = <<-'END'
#""
#"abc"
#"aaa\"aaa"
#"\x27"
#END

@data = @data.split("\n")

raw_count = @data.join("").length
count = @data.map do |line|
  line.undump
end.join("").length
print "Raw count = #{raw_count}\n"
print "Count = #{count}\n"
print "Answer = #{raw_count-count}\n"
