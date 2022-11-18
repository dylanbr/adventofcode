require "./data.rb"
width = 25
height = 6

# Test
#width = 3
#height = 2

layer_size = width * height
layers = @data.size / layer_size

fewest = nil
fewest_layer = 1
(0..layers-1).each do |layer|
  digits = Array.new(10).fill(0)
  (0..height-1).each do |y|
    (0..width-1).each do |x|
      index = (layer * layer_size) + ( (y*width) + x)
      pixel= @data[index]
      digits[pixel] += 1
    end
  end
  if fewest.nil? or digits[0] < fewest[0]
    fewest = digits
    fewest_layer = layer
  end
end

print "Fewest layer = #{fewest_layer}\n"
print "Fewest = #{fewest[1] * fewest[2]}\n"
