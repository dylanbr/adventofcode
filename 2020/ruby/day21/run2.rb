load "./data.rb"
#load "./test.rb"

@data = @data.split(/\n+/).map do |line|
  (ingredients, allergens) = line.split(/ \(contains /)
  ingredients = ingredients.split(/\s+/)
  allergens = allergens.split(/, /)
  allergens[-1].delete_suffix!(')')
  [ingredients, allergens]
end

@allergens = {}
@all_ingredients = []
@data.each do |item|
  item[1].each do |allergen|
    if @allergens[allergen].nil?
      @allergens[allergen] = []
    end
    @allergens[allergen].push(item[0].dup)
  end
  @all_ingredients.push(item[0].dup)
end


@all_allergenic = []
@allergens.each do |name, ingredients|
  ingredients = ingredients.reduce(:&)
  @allergens[name] = ingredients
  @all_allergenic.push(ingredients.dup)
end

@all_ingredients = @all_ingredients.reduce(&:concat).sort.uniq
@all_allergenic = @all_allergenic.reduce(&:concat).sort.uniq
@non_allergenic = @all_ingredients - @all_allergenic

@answer = 0
@data.each do |item|
  @non_allergenic.each do |ingredient|
    if item[0].include? ingredient
      @answer += 1
    end
  end
end

print "Part 1 = #{@answer}\n"

loop do
  changed = false
  @allergens.each do |name, items|
    if items.size == 1
      @allergens.each do |inner_name, inner_items|
        next if name == inner_name
        if inner_items.include? items[0]
          inner_items.delete(items[0])
          @allergens[inner_name] = inner_items
          changed = true
        end
      end
    end
  end

  break if not changed
end

@answer = @allergens.keys.sort.map do |name|
  @allergens[name][0]
end

print "Part 2 = #{@answer.join(",")}\n"

#print "#{@allergens}\n"
#print "All = #{@all_ingredients}\n"
#print "Allergenic = #{@all_allergenic}\n"
#print "Non-allergenic = #{@non_allergenic}\n"

#print "#{@data}\n"
