load "./data.rb"
#load "./test.rb"
#load "./test2.rb"

class Hash
  def range?(value)
    self['ranges'].any? do |range|
      range.include? value
    end
  end
end

@fields, @my_ticket, @other_tickets = @data.split("\n\n").map do |section|
  section.split(/\n+/).reject do |line|
    line.end_with? ":"
  end
end

@my_ticket = @my_ticket.first.split(",").map(&:to_i)

@fields = @fields.map do |field|
  name, values = field.split(": ")
  ranges = values.split(" or ").map do |value|
    min,max = value.split("-").map(&:to_i)
    min..max
  end
  { "name" => name, "ranges" => ranges, "positions" => (0..@my_ticket.size-1).to_a }
end

@other_tickets = @other_tickets.map do |line|
  line = line.split(",").map(&:to_i)
end.reject do |ticket|
  next true if not ticket.all? do |value|
    @fields.any? do |field|
      field.range? value
    end
  end
  false
end.each do |ticket|
  ticket.each_with_index do |value,index|
    @fields.each do |field|
      field['positions'].delete(index) if not field.range? value
    end
  end
end

loop do
  found = false
  singles = []
  @fields.each do |field|
    if field['positions'].one?
      singles << field['position'] = field['positions'].pop
    end
  end
  @fields.each do |field|
    singles.each do |single|
      field['positions'].delete(single)
      found = true
    end
  end
  break if not found
end

answer = @fields.select do |field|
  field['name'].start_with? "departure"
end.map do |field|
  @my_ticket[field['position']]
end.reduce(:*)

print "Answer = #{answer}\n"
#print "#{@my_ticket}\n"
#print "Number of other tickets = #{@other_tickets.size}\n"
#print "#{@other_tickets}\n"
#print "#{@data}\n"
