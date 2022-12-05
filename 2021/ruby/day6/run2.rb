load "./data.rb"
#load "./test.rb"

@fish = Hash.new(0)
@data = @data.chomp.split(",").map(&:to_i).each do |item|
  @fish[item] += 1
end

(1..256).each do
  @new = Hash.new(0)
  @fish.each do |state, count|
    state -= 1
    if state < 0
      @new[6] += count
      @new[8] += count
    else
      @new[state] += count
    end
  end
  @fish = @new
end

print "Total = #{@fish.values.sum}\n"
#print @fish
