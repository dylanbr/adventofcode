load "./data.rb"
#load "./test.rb"
#
@more = <<-EOF
  #D#C#B#A#
  #D#B#A#C#
EOF
@data = @data.split(/\n/).insert(3,*@more.split(/\n/))

@rooms = @data.select { |line| line.match(/[A-D]/) }.map do |line|
  line.gsub("#","").strip.split("").map do |target|
    target.ord - 'A'.ord
  end
end.transpose.map(&:reverse)

$room_to_hallway = [
  [ [0,1,nil], [1,nil], [nil,2], [nil,2,nil,3], [nil,2,nil,3,nil,4], [nil,2,nil,3,nil,4,nil,5], [nil,2,nil,3,nil,4,nil,5,6] ], # Room A
  [ [0,1,nil,2,nil], [1,nil,2,nil], [2,nil], [nil,3], [nil,3,nil,4], [nil,3,nil,4,nil,5], [nil,3,nil,4,nil,5,6] ],             # Room B
  [ [0,1,nil,2,nil,3,nil], [1,nil,2,nil,3,nil], [2,nil,3,nil], [3,nil], [nil,4], [nil,4,nil,5], [nil,4,nil,5,6] ],             # Room C
  [ [0,1,nil,2,nil,3,nil,4,nil], [1,nil,2,nil,3,nil,4,nil], [2,nil,3,nil,4,nil], [3,nil,4,nil], [4,nil], [nil,5], [nil,5,6] ], # Room D
]

$room_size = @rooms[0].size
class Game
  attr_accessor :rooms, :hallways, :total 

  def initialize(rooms,hallways=Array.new(7),total=0,states=Hash.new)
    @rooms = rooms
    @hallways = hallways
    @total = total
    @states = states
  end

  def skip_room(room)
    @rooms[room].reject { |r| r == room }.empty?
  end

  def score_path(room, hallway)
    $room_to_hallway[room][hallway].size
  end

  def allow_target(room)
    @rooms[room].reject {|b| b == room}.empty?
  end

  def allow_path(room, hallway, ignore_target_hallway=true)
    $room_to_hallway[room][hallway].reject do |p|
      p.nil? or (ignore_target_hallway and p == hallway) or @hallways[p].nil?
    end.empty?
  end

  def complete(rooms)
    done = true
    rooms.each_with_index do |room, target|
      if room.select { |t| t == target }.size != $room_size
        done = false
      end
    end
    return done
  end

  def turn
    scores = []
#    print "Turn with state #{[@rooms, @hallways]}\n"

    # Movement from hallway to rooms
    @hallways.each_with_index do |target, hallway|
      next if target.nil? or not allow_target(target) or not allow_path(target, hallway)
      # Only allow final moves
      new_rooms = @rooms.dup.map { |b| b.dup }.tap { |b| b[target].push target }
      new_hallways = @hallways.dup.tap { |p| p[hallway] = nil }

      extra = $room_size - new_rooms[target].size
      score = (score_path(target, hallway) + extra) * (10 ** target)
      result = final_score(new_rooms, new_hallways, total + score)
      if not result.nil?
        scores.push(result+score)
      end
    end

    # Movement from rooms to hallway
    @rooms.each_index do |room|
      next if skip_room(room)
      @hallways.each_index do |hallway|
        if allow_path(room, hallway, false)
          new_rooms = @rooms.dup.map { |b| b.dup }
          new_hallways = @hallways.dup
          target = new_rooms[room].pop
          new_hallways[hallway] = target
          extra = $room_size - new_rooms[room].size - 1
          score = (score_path(room, hallway) + extra) * (10 ** target)
          result = final_score(new_rooms, new_hallways, total + score)
          if not result.nil?
            scores.push(result + score)
          end
        end
      end
    end

    scores.min
  end

  def final_score(rooms, hallways, score)
    key = [rooms, hallways]
    if @states[key].nil? or @states[key] > score
      @states[key] = score
      if not complete(rooms)
        return Game.new(rooms, hallways, score, @states).turn
      else
        return 0
      end
    end
  end
end

print "Lowest possible score = #{Game.new(@rooms.dup).turn}\n"
