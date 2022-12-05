load "./data.rb"
#load "./test.rb"

@data = @data.split(",").map(&:to_i)



@attempts = {}
(@data.min..@data.max).each do |try|
  @moves = @data.map do |position|
    n = (position-try).abs
    (n * (n + 1) ) / 2 # https://en.wikipedia.org/wiki/Triangular_number
    #(1..n).reduce(0,:+)
  end
  @attempts[try] = @moves.sum
end

print "Minimum fuel = #{@attempts.values.min}\n"

