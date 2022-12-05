load "./data.rb"
#load "./test.rb"

# Simple 2d
#@data = <<-EOF
#--- scanner 0 ---
#0,2
#4,1
#3,3
#
#--- scanner 1 ---
#-1,-1
#-5,0
#-2,1
#EOF

def roll(v)
  [v[0],v[2],-v[1]]
end

def turn(v)
  [-v[1],v[0],v[2]]
end

def turn_cw(v)
  [-v[1],v[0],v[2]]
end

def turn_ccw(v)
  [v[1],-v[0],v[2]]
end

def sequence_old(a)
  Enumerator.new do |yielder|
    (1..2).each do
      (1..3).each do
        a = a.map { |v| roll(v) }
        yielder.yield(a)
        (1..3).each do
          a = a.map { |v| turn(v) }
          yielder.yield(a)
        end
      end
      a = a.map { |v| turn(roll(v)) }
    end
  end
end

def sequence(a)
  Enumerator.new do |yielder|
    (1..6).each do |ri|
      a = a.map { |v| roll(v) }
      yielder.yield(a)
      (1..3).each do
        if (ri % 2) == 0
          a = a.map { |v| turn_cw(v) }
        else
          a = a.map { |v| turn_ccw(v) }
        end
        yielder.yield(a)
      end
    end
  end
end

#  for roll_index in range(6):
#    m = roll(m)
#    yield(m)
#    for turn_index in range(3):
#      m = turn_cw(m) if roll_index % 2 == 0 else turn_ccw(m)
#      yield(m)

def dist(v1, v2)
  [v1[0]-v2[0], v1[1]-v2[1], v1[2]-v2[2]]
end

def dedist(v, distance)
  [v[0] + distance[0], v[1] + distance[1], v[2] + distance[2]]
end

def find_common(a, b)
  a.each do |av, ac|
    b.each do |bv|
      common = 0
      distance = dist(av, bv)
      b.each do |dv|
        if a.has_key? dedist(dv, distance)
          common += 1
        end
      end
      if common >= 12
        return distance
      end
    end
  end
  return nil
end

def find_with_rotations(a, b)
  sequence(b).each do |br|
    distance = find_common(a,br)
    if not distance.nil?
      print "MATCH!\n"
      br.map { |v| dedist(v, distance) }.each do |v|
        a[v] += 1
      end
      @distances.push distance
      return a
    end
  end
  return nil
end

@data = @data.split(/\n\n/).map do |scanner|
  (_, *positions) = scanner.split(/\n/)
  positions.map { |position| position.split(",").map(&:to_i) }
end

#print "Seq = #{sequence([[1,2,3],[4,5,6]]).to_a.size}\n"
#exit

@current = Hash.new(0)
@data[0].each do |v|
  @current[v] += 1
end
@remaining = @data.drop(1)
@distances = []
loop do
  print "Remaining = #{@remaining.size}\n"
  #print "Current = #{@current}\n"
  found = false
  break if @remaining.empty?
  @remaining.each do |target|
    print "Target = #{target}\n"
    check = find_with_rotations(@current, target)
    if not check.nil?
      @current = check
      @remaining.delete(target)
      found = true
      break;
    end
  end
  if not found
    print "Unable to find next match\n"
    exit
  end
end

max = 0
@distances.each do |a|
  @distances.each do |b|
    distance = (a[0]-b[0]).abs + (a[1]-b[1]).abs + (a[2]-b[2]).abs
    if distance > max
      max = distance
    end
  end
end

print "Size = #{@current.size}\n"
print "Max = #{max}\n"
