require "./data.rb"

def ancestors(node)
  list = []
  curr = node
  loop do
    list.push(curr)
    curr = @tree[curr]['parent']
    break if curr.nil?
  end
  list
end

@tree = Hash.new { |hash, key| hash[key] = {
  "parent" => nil,
  "children" => []
}}
for parent,child in @data
  @tree[child]['parent'] = parent
  @tree[parent]['children'].push(child)
end

you = ancestors('YOU')
san = ancestors('SAN')

print "Transfers required = #{ ((san + you) - (san & you)).length - 2}\n"
