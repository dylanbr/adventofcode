require './data.rb'

def gravity(a,b)
  return [0,0] if a == b
  return [1,-1] if b > a
  return [-1,1] if a > b
end

moons = []
@data.each do |moon|
  moons << {
    'initial'=>moon.dup,
    'position'=>moon,
    'velocity'=>[0,0,0]
  }
end

steps = []
singles = (0..moons.size-1)
pairs = singles.to_a.combination(2)
(0..2).each do |axis|
  step = 0
  loop do
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

    step += 1
    print "Step #{step}\r"

    check = moons.reduce(1) do |sum, moon|
      if moon['velocity'][axis] != 0 or moon['initial'][axis] != moon['position'][axis]
        break
      end
      sum
    end
    if not check.nil?
      print "Found cycle for axis #{axis} at #{step} steps\n"
      steps << step
      break
    end
  end
end

print "Total steps needed is #{steps.reduce &:lcm}\n"
