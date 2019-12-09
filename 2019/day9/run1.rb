require "./data.rb"
require './intcode-computer.rb'

inputs = [1]
outputs = []
instance = IntcodeComputer.new(@data.dup, inputs)
loop do
  output = instance.execute()
  break if output.nil?
  outputs.push(output)
end

print "Output = #{outputs.join(",")}\n"
