require './data.rb'

@base = [0,1,0,-1]

def fft(data)
  output = []
  count = 0
  data.each do |num|
    count2 = 0
    total = 0
    #debug = []
    data.each do |num2|
      base_index = ( (count2 + 1) / (count + 1) % 4)
      base = @base[base_index]
      total += num2 * base
      #debug << "#{num2}*#{base} [#{base_index}]"
      count2 += 1
    end
    total = total.to_s[-1]
    output.push(total)
    count += 1
    #print "[#{count}] #{debug.join(" + ")} = #{total}\n"
  end
  output.map(&:to_i)
end

count = 0
output = @data.dup
loop do
#  print "Phase ##{count+1}\n"
  output = fft(output)
  count += 1
  if count >= 100
    break
  end
end
print "Output = #{output.join("")[0..7]}\n"
