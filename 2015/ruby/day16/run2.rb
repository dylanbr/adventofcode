load './data.rb'

@input = @input.split(/\n/).map do |line|
  line = line.split(": ")
  line[1] = line[1].to_i
  line
end.to_h

@data = @data.split(/\n/).map do |line|
  items = line.match(/Sue (\d+): (.+)/).captures
  [items[0].to_i, items[1].split(", ").map do |attribute|
    attribute = attribute.split(": ")
    attribute[1] = attribute[1].to_i
    attribute
  end.to_h]
end.to_h

@data.each do |num, attributes|
  failed = false
  attributes.each do |attribute, value|
    case attribute
    when "cats", "trees"
      failed = true if value <= @input[attribute]
    when "pomeranians", "goldfish"
      failed = true if value >= @input[attribute]
    else
      failed = true if value != @input[attribute]
    end
  end
  if not failed
    print "Sue #{num}\n"
  end
end
