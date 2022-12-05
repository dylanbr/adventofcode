load "./data.rb"
#load "./test.rb"

#@method = "grid"
@method = "formula"

@data = @data.split(/\n\n/).map do |section|
  section.split(/\n/)
end

@points = @data[0].map do |point|
  point.split(",").map(&:to_i)
end

@folds = @data[1].map do |fold|
  fold = fold.sub("fold along ","").split("=")
  if @method == "grid"
    fold[0] = fold[0] == "x" ? 0 : 1
  end
  fold[1] = fold[1].to_i
  fold
end


if @method == "grid"
  # Grid method (slow due to transpose)
  @mx = @points.map { |p| p[0] }.max
  @my = @points.map { |p| p[1] }.max
  @map = Array.new(@my+1) { |i| i = Array.new(@mx+1,".") }
  @points.each do |point|
    (x,y) = point
    @map[y][x] = "#"
  end

  def print_map
    my = @map.size-1
    mx = @map[0].size-1
    (0..my).each do |y|
      (0..mx).each do |x|
        print @map[y][x]
      end
      print "\n"
    end
  end

  def fold_map(axis)
    @map = @map.transpose if axis == 1
    half = @map[0].size / 2
    @map = @map.map do |row|
      start = row[0,half].zip(row[half+1,half].reverse).map do |item|
        next "#" if item.include? "#"
        next "."
      end
      start
    end

    @map = @map.transpose if axis == 1
  end
  @folds.each do |fold|
    (axis, _) = fold
    fold_map(axis)
    break
  end

  @count = @map.reduce(0) do |total,row|
    total + row.reduce(0) do |total,point|
      next total + 1 if point == "#"
      total
    end
  end

  print "Points set = #{@count}\n"
else
  # Formula method
  @folds.each do |fold|
    (dir, pos) = fold
    case dir
    when "x"
      @points = @points.filter do |point|
        (x,_) = point
        next false if x == pos
        next true
      end.map do |point|
        (x,y) = point
        next point if x < pos
        [(pos*2)-x,y]
      end.uniq
    when "y"
      @points = @points.filter do |point|
        (_,y) = point
        next false if y == pos
        next true
      end.map do |point|
        (x,y) = point
        next point if y < pos
        [x,(pos*2)-y]
      end.uniq
    end
    break
  end

  print "Visibile = #{@points.size}\n"
end
