load "./data.rb"

#@data = <<-END
#123 -> x
#456 -> y
#x AND y -> d
#x OR y -> e
#x LSHIFT 2 -> f
#y RSHIFT 2 -> g
#NOT x -> h
#NOT y -> i
#END

@data = @data.split("\n").map do |line|
  (source,target) = line.split(" -> ")
  source = source.split(" ")
  if source.count == 1
    op = "set"
    params = [source[0]]
  elsif source.count == 2
    op = "not"
    params = [source[1]]
  else
    op = source[1].downcase
    params = [source[0], source[2]]
  end
  params = params.map { |param|
    if param[/\d+/] 
      param.to_i
    else
      param
    end
  }
  [target, [op, params]]
end.to_h
@data['b'] = [46065, []]
loop do 
  @found = false
  @data.each do |key, (op, raw_params)|
    if op.is_a? Numeric
      next
    end

    params = []
    has_params = true
    raw_params.each do |raw_param|
      if raw_param.is_a? Numeric
        params.push raw_param
      else
        if @data[raw_param][0].is_a? Numeric
          params.push @data[raw_param][0]
        else
          params.push "none"
          has_params = false
        end
      end 
    end
    if not has_params
      next
    end

    case op
    when "set"
      result = params[0]
      @found = true
    when "not"
      result = 65535-params[0]
      @found = true
    when "rshift"
      result = params[0] >> params[1]
      @found = true
    when "lshift"
      result = params[0] << params[1]
      @found = true
    when "and"
      result = params[0] & params[1]
      @found = true
    when "or"
      result = params[0] | params[1]
      @found = true
    end
    if @found
      @data[key] = [result, []]
    end
  end
  break if not @found
end
#print @data
print "\n\nWire A = #{@data['a'][0]}\n"
