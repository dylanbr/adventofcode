load './data.rb'

@data = @data.split(/\n+/)
# Demo data
#@data = %w(1721 979 366 299 675 1456)
@data = @data.map(&:to_i)

version = 2

if version == 1
  @data.each do |num1|
    @data.each do |num2|
      @data.each do |num3|
        if (num1 + num2 + num3) == 2020
          print "#{num1} + #{num2} + #{num3} = 2020\n"
          print "#{num1} * #{num2} * #{num3} = #{num1 * num2 * num3}\n"
          exit
        end
      end
    end
  end
else
  @data.each do |num1|
    target1 = 2020-num1
    next if target1 < 0
    @data.each do |num2|
      target2 = target1-num2
      next if target2 < 0
      if @data.include? target2
          print "#{num1} + #{num2} + #{target2} = 2020\n"
          print "#{num1} * #{num2} * #{target2} = #{num1 * num2 * target2}\n"
          exit
      end
    end
  end
end
