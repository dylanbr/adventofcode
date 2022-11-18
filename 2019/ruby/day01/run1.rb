require './data.rb'

def fuel(mass)
  mass / 3.floor - 2
end

@data = @data.split(/\n+/).map { |mass| mass.to_i }

print "Test #1 (1969): " + fuel(1969).to_s + "\n"
print "Test #2 (100756): " + fuel(100756).to_s + "\n"
print "Answer: " + @data.reduce(0) { |total, mass| fuel(mass) + total }.to_s + "\n"
