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
  line.dump
end.join("").length
print "Raw count = #{raw_count}\n"
print "Count = #{count}\n"
print "Answer = #{count-raw_count}\n"
