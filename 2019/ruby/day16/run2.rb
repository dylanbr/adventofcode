require './data.rb'

@base = [0,1,0,-1]
@base_lookup = []

def lookup(data)
  count = 0
  data.each do |num|
    @base_lookup[count] = [] if @base_lookup[count].nil?
    count2 = 0
    data.each do |num2|
      base_index = ( (count2 + 1) / (count + 1) % 4)
      @base_lookup[count][count2] = @base[base_index]
      count2 += 1
    end
    count += 1
  end
end

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
      #debug << "#{num2}*#{@base_lookup[count][count2]} "
      count2 += 1
    end
    total = total.abs % 10
    output.push(total)
    count += 1
    #print "[#{count}] #{debug.join(" + ")} = #{total}\n"
  end
  output
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
print "\n\n"

output = @data.dup
offset = output.join("")[0..6].to_i
output = (output * 10000)[offset..-1]
count = 0
loop do
  output.each_with_index do |value, index|
    i = output.size - index - 1
    next if output[i+1].nil?
    output[i] = (output[i] + output[i+1]) % 10
  end
  count +=1
  if count >= 100
    break
  end
end
print "Offset = #{offset}, output size = #{output.size}\n"
print "Message = #{output[0..7].join("")}\n"

