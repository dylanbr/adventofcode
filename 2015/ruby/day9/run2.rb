load "./data.rb"

@datat = <<-END
London to Dublin = 464
London to Belfast = 518
Dublin to Belfast = 141
END

@data = @data.split("\n").map do |line|
  line.scan(/(.*) to (.*) = (\d+)/).flatten
end

cities = @data.map do |line|
  line.slice(0,2)
end.flatten.uniq

distances = @data.map do |line|
  [ [line[0] + "_" + line[1], line[2].to_i], [line[1] + "_" + line[0], line[2].to_i] ]
end.flatten(1).to_h

routes = cities.permutation.map do |combo|
  combo.each_cons(2).map do |item|
    item.join("_")
  end.map do |item|
    distances[item]
  end
end.select do |combo|
  not combo.include? nil
end.map do |combo|
  combo.reduce(&:+)
end
print "Longest route is #{routes.max}\n"
#print distances
#print @data
