load "./data.rb"
#load "./test.rb"

($enhance, @image) = @data.split(/\n\n/)
$enhance = $enhance.gsub("\n","").chars
@image = @image.split(/\n/).map(&:chars)

$pixels = [
  [-1, -1], [ 0, -1], [ 1, -1],
  [-1,  0], [ 0,  0], [ 1,  0],
  [-1,  1], [ 0,  1], [ 1,  1]
]

$default = $enhance[0]

class Image
  def initialize(input=nil, default=".")
    @ix = 4
    @iy = 4
    @mx = input[0].size + @ix
    @my = input.size + @iy
    @map = Array.new(@my) { Array.new(@mx,default) }
    if not input.nil?
      input.each_with_index do |row, y|
        row.each_with_index do |val, x|
          @map[y+(@iy/2)][x+(@ix/2)] = input[y][x]
        end
      end
    end
  end

  def set(x,y,val)
    @map[y][x] = val
  end

  def to_s
    output = ""
    (0..@my-1).each do |y|
      (0..@mx-1).each do |x|
        output += @map[y][x]
      end
      output += "\n"
    end
    return output
  end

  def enhance(default=".")
    new_image = Image.new(@map,default) 
    (1..@my-2).each do |y|
      (1..@mx-2).each do |x|
        num = ""
        $pixels.each do |pixel|
          px = x + pixel[0]
          py = y + pixel[1]
          num += @map[py][px] 
        end
        num = num.gsub("#","1").gsub(".","0").to_i(2)
        char = $enhance[num]
        new_image.set(x+(@ix/2),y+(@iy/2),char)
      end
    end
    ( (@iy/2)..( @my+(@iy/2)-1 ) ).each do |y|
      new_image.set(@ix/2,y,default)
      new_image.set(@mx+(@ix/2)-1,y,default)
    end
    ( (@ix/2)..( @mx+(@ix/2)-1 ) ).each do |x|
      new_image.set(x,@iy/2,default)
      new_image.set(x,@my+(@iy/2)-1,default)
    end
    return new_image
  end

  def count
    total = 0
    (0..@my-1).each do |y|
      (0..@mx-1).each do |x|
        if @map[y][x] == "#"
          total += 1
        end
      end
    end
    return total
  end
end

@image = Image.new(@image)
print "Initial image\n#{@image.to_s}\n\n"
default = "#"
(1..2).each do |time|
  @image = @image.enhance(default)
  print "Enhancement ##{time}\n#{@image.to_s}\n\n"
  if default == "."
    default = "#"
  else
    default = "."
  end
end
print "Count = #{@image.count}\n"


