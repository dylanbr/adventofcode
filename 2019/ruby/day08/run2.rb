require "./data.rb"
width = 25
height = 6

# Test
#width = 2
#height = 2

layer_size = width * height
layers = @data.size / layer_size

image = []
(0..layers-1).each do |layer|
  layer = layers-1 - layer
  (0..height-1).each do |y|
    image[y] = [] if image[y].nil?
    (0..width-1).each do |x|
      index = (layer * layer_size) + ( (y*width) + x)
      pixel= @data[index]
      image[y][x] = pixel if image[y][x].nil? or pixel < 2
    end
  end
end

image.each do |line|
  output = line.map { |pixel|
    if pixel == 0
      "\e[0m "
    else
      "\e[7m "
    end
  }
  print output.join("") + "\e[0m\n"
end
