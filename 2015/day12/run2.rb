require 'json'
load './data.rb'

class Tree
  def initialize(data)
    @data = data
  end

  def find_nums(node=@data,nums=[])
    if node.is_a? Hash
      if not node.each_value.any? { |v| v == "red" }
        node.each_value do |v|
          find_nums(v, nums)
        end
      end
    elsif node.is_a? Array
      node.each do |v|
        find_nums(v, nums)
      end
    else
      nums.push(node)
    end
    return nums.select do |num|
      num.is_a? Integer
    end
  end

  def to_s
    print @data
  end
end

tree = Tree.new(JSON.parse(@data))
print tree.find_nums().reduce(&:+)
