load './data.rb'
#load './test.rb'

class Combos
  def initialize(count, max, start = 0)
    @count = count
    @max = max
    @start = start
  end

  def to_a
    if @count == 1
      return [[@max - @start]]
    end
    out = []
    0.upto(@max- @start).map do |i|
      Combos.new(@count - 1, @max, @start + i).to_a.each do |a|
        out.push([i].concat(a))
      end
    end
    return out
  end
end

class Ingredient
  def initialize(name, capacity, durability, flavor, texture, calories)
    @name = name
    @capacity = capacity
    @durability = durability
    @flavor = flavor
    @texture = texture
    @calories = calories
  end

  def productOrZero(x, y)
    a = x * y
    if a > 0 
      return a
    else
      return 0
    end
  end

  def score(qty)
    return [@capacity*qty, @durability*qty, @flavor*qty, @texture*qty]
  end
  
  def calories(qty)
    return @calories * qty
  end

  def name
    @name
  end
end

@ingredients = @data.split(/\n/).map do |ingredient|
  ingredient.match(/(?<name>\w+): capacity (?<capacity>-?\d+), durability (?<durability>-?\d+), flavor (?<flavor>-?\d+), texture (?<texture>-?\d+), calories (?<calories>-?\d+)/).named_captures.map do |key, value|
    next [key, value] if key == 'name'
    [key, value.to_i]
  end.to_h
end.map do |ingredient|
  Ingredient.new(ingredient['name'], ingredient['capacity'], ingredient['durability'], ingredient['flavor'], ingredient['texture'], ingredient['calories'])
end

@highest = 0
Combos.new(@ingredients.size, 100).to_a.each do |combo|
  @total = []
  @calories = []
  @ingredients.each_with_index do |ingredient, index|
    @total.push(ingredient.score(combo[index]))
    @calories.push(ingredient.calories(combo[index]))
  end
  next if @calories.reduce(&:+) != 500
  @total = @total.shift.zip(*@total). map do |total|
    total = total.reduce(&:+)
    if total > 0
      next total
    else
      next 0
    end
  end.reduce(&:*)
  if @total > @highest
    @highest = @total
  end
end

print "Highest = #{@highest}\n"

