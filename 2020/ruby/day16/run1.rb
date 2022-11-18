load "./data.rb"
#load "./test.rb"

@data = @data.split("\n\n")
@fields = @data[0].split(/\n+/).map do |field|
  name, values = field.split(": ")
  values = values.split(" or ").map do |value|
    min,max = value.split("-").map(&:to_i)
    min..max
  end
  [name,values]
end
@my_ticket = @data[1].split(/\n+/).map do |line|
  line = line.split(",").map(&:to_i)
end.reject do |line|
  line.size < 2
end

@other_tickets = @data[2].split(/\n+/).map do |line|
  line = line.split(",").map(&:to_i)
end.reject do |line|
  line.size < 2
end

answer = @other_tickets.reduce([]) do |invalids,ticket|
  ticket.each do |value|
    valid = false
    @fields.each do |field|
      field[1].each do |range|
        if range.include? value
          valid = true
        end
      end
    end
    if not valid
      invalids.push(value)
    end
  end
  invalids
end

print "Answer = #{answer.reduce(:+)}\n"

#print "#{@fields}\n"
#print "#{@my_ticket}\n"
#print "#{@other_tickets}\n"
#print "#{@data}\n"
