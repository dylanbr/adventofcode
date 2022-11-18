load "./data.rb"
#load "./test.rb"
#load "./test2.rb"

@players = @data.split(/\n\n/).map do |player|
  player.split(/\n+/)[1..-1].map(&:to_i)
end

def round(players,level=1)
  seen = {}
  loop do
    seen_hash = players.map do |player|
      player.join("_")
    end.join("__")
    #print "PLAYERS = #{players}\n"
    if seen.has_key? seen_hash
      players[1] = []
      #print "SEEN[#{seen.size}]\n"
    else
      seen[seen_hash] = true
      cards = [players[0].shift, players[1].shift]
      #cards = players.map do |player|
      #  player.shift
      #end

      recursive = (players[0].size >= cards[0]) && (players[1].size >= cards[1])
      #recursive = cards.each_with_index.all? do |card, player|
      #  players[player].size >= card 
      #end

      if recursive
        #print "RECUR[#{level}]\n"
        #print "#{cards}\n"
        #print "#{players}\n"
        hands = [players[0][0..cards[0]-1], players[1][0..cards[1]-1]]
        result = round(hands, level+1)
        #result = round(players.each_with_index.map do |hand, player|
          #print "giving #{player} a hand of #{cards[player]}\n"
        #  hand[0..cards[player]-1]
        #end,level+1)
        #print "BACK[#{level}]\n"
        winner = (result.index([])+1)%2
      else
        winner = cards.index(cards.max)
      end
      cards = [cards[winner],cards[(winner+1)%2]]
      players[winner] += cards
    end
    break if players.any? []
  end
  players
end

winner = round(@players).find do |player|
  player.size > 0
end

score = winner.each_with_index.reduce(0) do |total, (card, index)|
  total + (winner.size-index) * card
end
print "Part 2 = #{score}\n"
print "winner = #{winner}\n"
#print "#{@players}\n"
#print "#{@data}\n"
