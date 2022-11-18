load "./data.rb"
#load "./test.rb"

@dimensions = 3

@cubes = Hash.new(0)
@data = @data.split(/\n+/).each_with_index do |line,y|
  line.split("").each_with_index do |state,x|
    if state == "#"
      @cubes[[x,y].fill(0,2..@dimensions-1)] = 1
    end
  end
end

def add_pos(pos_a,pos_b)
  [pos_a,pos_b].transpose.map(&:sum)
end

@neighbours = [-1,0,1].repeated_permutation(@dimensions).to_a.reject do |neighbour|
  neighbour == [].fill(0,0..@dimensions-1)
end

last = @cubes.dup
(1..6).each do |cycle|
  curr = Hash.new(0)
  last.each_key do |pos|
    primary_actives = 0
    @neighbours.each do |neighbour|
      neighbour_pos = add_pos(pos, neighbour)
      if last.has_key? neighbour_pos
        primary_actives += 1
      else
        neighbour_actives = 0
        @neighbours.each do |neighbour2|
          if last.has_key? add_pos(neighbour_pos, neighbour2)
            neighbour_actives += 1
          end
          break if neighbour_actives > 3
        end
        if neighbour_actives == 3
          curr[neighbour_pos] = 1
        end
      end
    end
    if primary_actives == 2 or primary_actives == 3
      curr[pos] = 1
    end
  end
  last = curr.dup
end

print "#{last.size}\n"
#print "#{@neighbours.size}\n"
#print "#{@cubes}\n"
