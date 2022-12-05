require 'benchmark'

load "./data.rb"
load "./test.rb"

#@times = 18
#@times = 80
@times = 256

#@method = "in-place"
#@method = "rotate"
@method = "hash"

@methods = ["in-place", "rotate", "hash"]

@methods.each do |method|
  time = Benchmark.measure {
    case method
    when "in-place"
      @fish = Array.new(9,0)
      @data.chomp.split(",").map(&:to_i).each do |item|
        @fish[item] +=1
      end

      (6..@times+6).each do |spawn|
        @fish[spawn % 9] += @fish[(spawn + 2) % 9]
      end
    when "rotate"
      @fish = Array.new(9,0)
      @data.chomp.split(",").map(&:to_i).each do |item|
        @fish[item] +=1
      end
      (1..@times).each do
        @fish.rotate!(1)
        @fish[6] += @fish[8]
      end
    when "hash"
      @fish = Hash.new(0)
      @data = @data.chomp.split(",").map(&:to_i).each do |item|
        @fish[item] += 1
      end

      (1..@times).each do
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
      @fish = @fish.values
    end
  }
  print "Using \"#{method}\" method #{@times} times: #{@fish.sum}\n"
  print "\tTook #{time.format("%r")}\n"
end

