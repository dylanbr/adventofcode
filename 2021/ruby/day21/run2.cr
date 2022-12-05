class Game
	@data : String
	@starts : Array(Int64)
	@dice : Array(Int64)
	@found : Hash(Array(Array(Int64) | Int64), Array(Int64))

	def initialize
		@data = <<-EOF
Player 1 starting position: 1
Player 2 starting position: 10
EOF
		@starts = @data.split(/\n/).map do |start|
		  match =start.match(/: (\d+)/)
		  if !match.nil?
			  match[1].to_i64
		  else
			  0.to_i64
		  end
		end

		@dice = [1.to_i64,2.to_i64,3.to_i64]
		@dice = @dice.cartesian_product(@dice, @dice).map do |dice|
			dice.sum
		end
		@found = Hash(Array(Array(Int64) | Int64), Array(Int64)).new
	end

	def go(pos, scores=[0.to_i64,0.to_i64], player=0.to_i64) : Array(Int64)
		#  print "Pos = #{pos}, scores = #{scores}, player = #{player}\n"
  		hash = [pos, scores, player]
  		return @found[hash] if @found.has_key? hash
		return [1.to_i64, 0.to_i64] if scores[0] >= 21
		return [0.to_i64, 1.to_i64] if scores[1] >= 21

  		@found[hash] = @dice.map do |dice|
			new_pos = pos.dup
			new_pos[player] = (new_pos[player] - 1 + dice) % 10 + 1
			new_scores = scores.dup
			new_scores[player] += new_pos[player]
			go(new_pos, new_scores, (player+1) % 2)
  		end.transpose.map do |result|
			result.sum
		end
	end

	def get_starts
		return @starts
	end
end

def run
	game = Game.new
	print "Winner in most universes = #{game.go(game.get_starts.dup).max}\n"
end
run
