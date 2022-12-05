load "./data.rb"
#load "./test.rb"

@starts = @data.split(/\n/).map do |start|
  start.match(/: (\d+)/)[1].to_i
end

@dice = [1,2,3]
@dice = @dice.product(@dice, @dice).map(&:sum)

@found = Hash.new(0)
def go(pos, scores=[0,0], player=0)
#  print "Pos = #{pos}, scores = #{scores}, player = #{player}\n"
  hash = [pos, scores, player]
  return @found[hash] if @found.has_key? hash
  return [1, 0] if scores[0] >= 21
  return [0, 1] if scores[1] >= 21

  @found[hash] = @dice.map do |dice|
    new_pos = pos.dup
    new_pos[player] = (new_pos[player] - 1 + dice) % 10 + 1
    new_scores = scores.dup
    new_scores[player] += new_pos[player]
    go(new_pos, new_scores, (player+1) % 2)
  end.transpose.map(&:sum)
end

print "Winner in most universes = #{go(@starts.dup).max}\n"
