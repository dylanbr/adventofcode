load "./data.rb"
#load "./test.rb"

@players = @data.split(/\n\n/).map do |player|
  player.split(/\n+/)[1..-1].map(&:to_i)
end

loop do
  cards = @players.map do |player|
    player.shift
  end
  winner = cards.index(cards.max)
  @players[winner] += cards.sort.reverse
  #print "#{@players}\n"
  #print "#{cards}\n"
  #print "#{winner}\n"

  break if @players.any? []
end

winner = @players.find do |player|
  player.size > 0
end

score = winner.each_with_index.reduce(0) do |total, (card, index)|
  total + (winner.size-index) * card
end
print "Part 1 = #{score}\n"
print "winner = #{winner}\n"
#print "#{@players}\n"
#print "#{@data}\n"
