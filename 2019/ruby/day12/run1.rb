require './data.rb'

def gravity(a,b)
  return [0,0] if a == b
  return [1,-1] if b > a
  return [-1,1] if a > b
end

moons = []
@data.each do |moon|
  moons << {
    'position'=>moon,
    'velocity'=>[0,0,0]
  }
end

singles = (0..moons.size-1)
pairs = singles.to_a.combination(2)
steps = 1000
(0..2).each do |axis|
  (1..steps).each do
    pairs.each do |pair|
      one = moons[pair[0]]
      two = moons[pair[1]]
      g = gravity(one['position'][axis], two['position'][axis])
      one['velocity'][axis] += g[0]
      two['velocity'][axis] += g[1]
    end
    singles.each do |moon|
      moons[moon]['position'][axis] += moons[moon]['velocity'][axis]
    end
  end
end

energy = moons.reduce(0) do |sum, moon|
  potential = moon['position'].reduce(0) { |sum, axis| sum + axis.abs }
  kinetic = moon['velocity'].reduce(0) { |sum, axis| sum + axis.abs }
  sum + potential * kinetic
end
print "Energy = #{energy}\n"
