load "./data.rb"
#load "./test.rb"

@data = @data.split(/\n+/)

class Calculator
  def evaluate(string)
    tokens = string.gsub(/\s/,"").scan(/\d+|\D/)
    run(parse(tokens))
  end

  def parse(tokens)
    loop do
      next if brackets(tokens)
      next if operation(tokens,['+','-','*','/'])
      break
    end
    tokens[0]
  end

  def brackets tokens
    start = tokens.index("(")
    return false if start.nil?

    curr = start + 1
    count = 1
    while count > 0 do
      count += 1 if tokens[curr] == "("
      count -= 1 if tokens[curr] == ")"
      curr += 1
    end
    tokens.insert(start,parse(tokens.slice!(start..curr-1)[1..-2]))
    true
  end

  def operation tokens, ops
    start = ops.map { |c| tokens.index(c) }.compact.min
    return false if start.nil?

    op = tokens[start]
    start -= 1
    subTokens = tokens.slice!(start..start + 2)
    tokens.insert(start,[op,subTokens[0],subTokens[2]])
    true
  end

  def run(tree)
    return tree.to_f if tree.is_a?(String)
    op = tree.shift
    params = tree.map do |node|
      if node.is_a?(Array)
        run(node)
      else
        node.to_f
      end
    end
    params.reduce(op.to_sym)
  end
end

@answer = @data.map do |calculation|
  Calculator.new.evaluate(calculation)
end.reduce(:+).to_i
print "#{@answer}\n"
#print "#{@data}\n"
