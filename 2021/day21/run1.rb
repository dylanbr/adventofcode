load "./data.rb"
#load "./test.rb"

@starts = @data.split(/\n/).map do |start|
  start.match(/: (\d+)/)[1].to_i
end

@pos = @starts.dup()
@scores = [0,0]
@dice = 1
@player = 0
@rolls = 0
loop do
  move = 0
  (1..3).each do
    move += @dice
    @rolls += 1
    @dice += 1
    if @dice > 100
      @dice = 1
    end
  end
  before = @pos[@player]
  @pos[@player] = (@pos[@player] - 1 + move) % 10 + 1
  #print "Player #{@player+1} moves #{move} from #{before} to #{@pos[@player]} dice on #{@dice}\n"
  @scores[@player] += @pos[@player]
  @player = (@player+1) % 2
  break if @scores.max >= 1000
end

print "Losing score #{@scores.min} * rolls #{@rolls} = #{@scores.min * @rolls}\n"
